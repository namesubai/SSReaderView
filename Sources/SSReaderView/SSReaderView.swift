//
//  SSReaderView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/6.
//

import UIKit


@objc public protocol SSReaderDataSource: NSObjectProtocol {
    func pageCountOfReaderView(readerView: SSReaderView) -> Int
    func pageContentView(readerView: SSReaderView, pageNum: Int, containerView: UIView?) -> UIView
    func pageIdentifier(readerView: SSReaderView, pageNum: Int) -> String?
    @objc optional func topToolView(readerView: SSReaderView) -> UIView?
    @objc optional func bottomToolView(readerView: SSReaderView) -> UIView?
}

@objc public protocol SSReaderDelegate: NSObjectProtocol {
    func pageNum(readerView: SSReaderView, pageNum: Int)
}

extension SSReaderView {
   public enum DisplayType {
        case pageCurl
        case horizontalScroll
        case verticalScroll
        case horizontalCoverScroll
    }
}

public class SSReaderView: UIView {
    
    enum TapEvent {
        case none, left, center, right
    }
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    
    private lazy var layout: SSReaderFlowLayout = {
        let layout = SSReaderFlowLayout(displayType: .horizontalScroll)
        layout.dataSource = self
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    public var currentPage: Int = -1 {
        didSet {
            if let delegate = delegate, currentPage != oldValue, delegate.responds(to: #selector(SSReaderDelegate.pageNum(readerView:pageNum:))) {
                delegate.pageNum(readerView: self, pageNum: currentPage)
            }
        }
    }
    
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        return tap
    }()
    
    private var tapEvent: TapEvent = .none {
        didSet {
            switch tapEvent {
            case .left:
                if currentDisplayType != .pageCurl, currentPage - 1 >= 0 {
                    transitionToPage(pageNum: currentPage - 1, animated: true)
                }
            case .right:
                if currentDisplayType != .pageCurl, currentPage + 1 < self.dataSource!.pageCountOfReaderView(readerView: self) {
                    transitionToPage(pageNum: currentPage + 1, animated: true)
                }
            case .center:
                tapCenter()
            default:
                break
            }
        }
    }
    
    public weak var dataSource: SSReaderDataSource? = nil
    public weak var delegate: SSReaderDelegate? = nil
    public var currentDisplayType: SSReaderView.DisplayType = .pageCurl
    public var toolViewAnimationDuration: TimeInterval = 0.3
    
    private var contentViews = [String : UIView.Type]()
    private var willPreviousTransitionToViewController: UIViewController? = nil
    private var willNextTransitionToViewController: UIViewController? = nil
    private var willTransitionToViewController: UIViewController? = nil
    private var topToolView: UIView?
    private var bottomToolView: UIView?
    private var isShowToolView: Bool = false
    private var isTransitioning: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil {
            makeUI()
        }
    }
    
    private func makeUI() {
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.ss_superViewController?.addChild(pageViewController)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self.ss_superViewController)
        
        
        addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        let point = tap.location(in: tap.view)
        let viewFrame = tap.view!.frame
        let leftFrame = CGRect(x: 0, y: 0, width: viewFrame.width / 3, height: viewFrame.height)
        let centerFrame = CGRect(x: viewFrame.width / 3, y: 0, width: viewFrame.width / 3, height: viewFrame.height)
        let rightFrame = CGRect(x: viewFrame.width * 2 / 3, y: 0, width: viewFrame.width / 3, height: viewFrame.height)
        if leftFrame.contains(point) {
            if isShowToolView {
                tapEvent = .center
            } else {
                tapEvent = .left
            }
        }
        
        if centerFrame.contains(point) {
            tapEvent = .center
        }
        
        if rightFrame.contains(point) {
            if isShowToolView {
                tapEvent = .center
            } else {
                tapEvent = .right
            }
        }
    }
    
    private func tapCenter() {
        isShowToolView = !isShowToolView
        if isShowToolView {
            if let topToolView = topToolView {
                addSubview(topToolView)
                topToolView.frame = CGRect(x: 0, y: -topToolView.frame.height, width: topToolView.frame.width, height: topToolView.frame.height)
                UIView.animate(withDuration: toolViewAnimationDuration) {
                    topToolView.transform = CGAffineTransform.init(translationX: 0, y: topToolView.frame.height)
                }
            }
            
            if let bottomToolView = bottomToolView {
                addSubview(bottomToolView)
                bottomToolView.frame = CGRect(x: 0, y: frame.height, width: bottomToolView.frame.width, height: bottomToolView.frame.height)
                UIView.animate(withDuration: toolViewAnimationDuration) {
                    bottomToolView.transform = CGAffineTransform.init(translationX: 0, y: -bottomToolView.frame.height)
                }
            }
            collectionView.isUserInteractionEnabled = false
            pageViewController.view.isUserInteractionEnabled = false
        } else {
            if let topToolView = topToolView {
                UIView.animate(withDuration: toolViewAnimationDuration) {
                    topToolView.transform = CGAffineTransform.identity
                }
            }
            
            if let bottomToolView = bottomToolView {
                UIView.animate(withDuration: toolViewAnimationDuration) {
                    bottomToolView.transform = CGAffineTransform.identity
                }
            }
            
            collectionView.isUserInteractionEnabled = true
            pageViewController.view.isUserInteractionEnabled = true
        }
    }
    
    public func switchReaderDisplayType(_ displayType: SSReaderView.DisplayType) {
        self.currentDisplayType = displayType
        if currentPage == -1 {
            currentPage = 0
        }
        switch displayType {
        case .pageCurl:
            insertSubview(pageViewController.view, at: 0)
            self.collectionView.removeFromSuperview()
            transitionToPage(pageNum: currentPage)
        default:
            pageViewController.view.removeFromSuperview()
            insertSubview(self.collectionView, at: 0)
            layout.displayType = displayType
            transitionToPage(pageNum: currentPage)
        }
    }
    
    public func transitionToPage(pageNum: Int, animated: Bool = false) {
        switch currentDisplayType {
        case .pageCurl:
            let contentView = dataSource?.pageContentView(readerView: self, pageNum: pageNum, containerView: nil)
            let vc = SSReaderPageChildViewController(contentView: contentView)
            pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            currentPage = pageNum
        default:
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.setContentOffset(layout.currentContentOffset(count: pageNum), animated: animated)
        }
    }
    
    public func reloadData() {
        switchReaderDisplayType(currentDisplayType)
        topToolView = self.dataSource?.topToolView?(readerView: self)
        bottomToolView = self.dataSource?.bottomToolView?(readerView: self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



extension SSReaderView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        ///向前
        if currentPage <= 0 {
            return nil
        }
        let contentView = dataSource?.pageContentView(readerView: self, pageNum: currentPage - 1, containerView: nil)
        let vc = SSReaderPageChildViewController(contentView: contentView)
        willPreviousTransitionToViewController = vc
        return vc

    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        ///向后
        if currentPage + 1 >= dataSource?.pageCountOfReaderView(readerView: self) ?? 0 {
            return nil
        }
        let contentView = dataSource?.pageContentView(readerView: self, pageNum: currentPage + 1, containerView: nil)
        let vc = SSReaderPageChildViewController(contentView: contentView)
        willNextTransitionToViewController = vc
        return vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let willPreviousTransitionToViewController = willPreviousTransitionToViewController,  !previousViewControllers.contains(willPreviousTransitionToViewController), willTransitionToViewController == willPreviousTransitionToViewController {
                currentPage = max(0, currentPage - 1)
            }
            
            if let willNextTransitionToViewController = willNextTransitionToViewController,  !previousViewControllers.contains(willNextTransitionToViewController), willTransitionToViewController == willNextTransitionToViewController {
                currentPage = min(currentPage + 1, (dataSource?.pageCountOfReaderView(readerView: self) ?? 1) - 1)
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        willTransitionToViewController = pendingViewControllers.first
    }
    
}

extension SSReaderView: UICollectionViewDataSource, SSReaderFlowLayoutDelegate, SSReaderFlowLayoutDataSoure {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        if let identifer = self.dataSource?.pageIdentifier(readerView: self, pageNum: indexPath.row) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifer, for: IndexPath(item: indexPath.row, section: 0)) as! SSReaderContentCell
            let conttainerView = self.dataSource?.pageContentView(readerView: self, pageNum: indexPath.row, containerView: cell.containerView)
            if cell.containerView == nil, let conttainerView = conttainerView {
                cell.containerView = conttainerView
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
     
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.pageCountOfReaderView(readerView: self) ?? 0
    }
    
    public func pageNum(flowLayout: SSReaderFlowLayout, pageIndex: Int) {
        currentPage = pageIndex
        
    }
    
    public func heigtOfVerticalScrollPage(flowLayout: SSReaderFlowLayout, pageIndex: Int) -> CGFloat? {
        return nil
    }
}

extension SSReaderView {
    public func register(contentView: UIView.Type, contentViewWithReuseIdentifier identifier: String) {
        contentViews[identifier] = contentView
        collectionView.register(SSReaderContentCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    
    public func dequeueReusableContentView(withReuseIdentifier identifier: String, for pageNum: Int) -> UIView {
        if self.currentDisplayType != .pageCurl, let cell = self.collectionView.cellForItem(at: IndexPath(row: pageNum, section: 0)) as? SSReaderContentCell, let containerView = cell.containerView {
            return containerView
        }
        let contentViewClass = contentViews[identifier]
        assert(contentViewClass != nil, "请调用register(contentView：contentViewWithReuseIdentifier：）")
        var contentView = contentViewClass!.init()
        return contentView
    }
    
    public func pageContentView(pageNum: Int) -> UIView? {
        if currentDisplayType  == .pageCurl {
          return  (self.pageViewController.viewControllers?.first as? SSReaderPageChildViewController)?.contentView
        } else {
            let cell = collectionView.cellForItem(at: IndexPath(item: pageNum, section: 0)) as? SSReaderContentCell
            return cell?.containerView
        }
    }
}

private var cellViewKey: Int8 = 0
extension UIView {
    var ss_superViewController: UIViewController?  {
        var next = self.next
        while next != nil {
            if next is UIViewController {
                return next as? UIViewController
            } else {
                next = next!.next
            }
        }
        return nil
    }
    
}
