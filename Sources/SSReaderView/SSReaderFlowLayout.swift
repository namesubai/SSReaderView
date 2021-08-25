//
//  SSReaderFlowLayout.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/6.
//

import UIKit

public protocol SSReaderFlowLayoutDataSoure: NSObjectProtocol {
    func heigtOfVerticalScrollPage(flowLayout: SSReaderFlowLayout, pageIndex: Int) -> CGFloat?
}

@objc public protocol SSReaderFlowLayoutDelegate: NSObjectProtocol {
    func pageNum(flowLayout: SSReaderFlowLayout, pageIndex: Int)
}

public class SSReaderFlowLayout: UICollectionViewFlowLayout {
    
    
    var displayType: SSReaderView.DisplayType = .horizontalScroll {
        didSet {
            invalidateLayout()
        }
    }
    
    weak var dataSource: SSReaderFlowLayoutDataSoure? = nil
    weak var delegate: SSReaderFlowLayoutDelegate? = nil
    private var currentPage: Int = 0 {
        
        didSet {
            if let delegate = delegate, delegate.responds(to: #selector(SSReaderFlowLayoutDelegate.pageNum(flowLayout:pageIndex:))), currentPage != oldValue, currentPage >= 0 {
                delegate.pageNum(flowLayout: self, pageIndex: currentPage)
            }
        }
    }
    
    init(displayType: SSReaderView.DisplayType) {
        self.displayType = displayType
        super.init()
        
    }
    
    public override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else {
            return
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            collectionView.ss_superViewController?.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        switch self.displayType {
        case .horizontalScroll, .horizontalCoverScroll:
            scrollDirection = .horizontal
            itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            collectionView.isPagingEnabled = true
        case .verticalScroll:
            itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            scrollDirection = .vertical
            collectionView.isPagingEnabled = false
            collectionView.showsVerticalScrollIndicator = true

        default: break
        }
        
    }
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override var collectionViewContentSize: CGSize {
        var size = super.collectionViewContentSize
        guard let collectionView = collectionView else {
            return size
        }
        if displayType == .verticalScroll {

            let totalHeight = [Int](0..<collectionView.numberOfItems(inSection: 0)).reduce(0.0, { result, num in
                result + (dataSource?.heigtOfVerticalScrollPage(flowLayout: self, pageIndex: num) ?? collectionView.frame.height)
            })
            size.height = totalHeight
        }
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        guard let collectionView = collectionView  else {
            return attributes
        }
        
        
        
        if self.displayType == .verticalScroll {
            let rowCount = collectionView.numberOfItems(inSection: 0)
            var totalHeight: CGFloat = 0
            for index in 0..<rowCount {
                totalHeight += dataSource?.heigtOfVerticalScrollPage(flowLayout: self, pageIndex: index) ?? collectionView.frame.height
                if totalHeight > collectionView.contentOffset.y {
                    self.currentPage = index
                    break
                }
            }
            (attributes ?? []).forEach({ attr in
                let indexPath = attr.indexPath
                let lastRow = max(0, indexPath.row - 1)
                let height = dataSource?.heigtOfVerticalScrollPage(flowLayout: self, pageIndex: indexPath.row) ?? collectionView.frame.height
                var lastTotalHeight: CGFloat = 0
                if indexPath.row > 0 {
                    lastTotalHeight = [Int](0...lastRow).reduce(0.0) { result, row in
                        result + (dataSource?.heigtOfVerticalScrollPage(flowLayout: self, pageIndex: row) ?? collectionView.frame.height)
                    }
                }
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.layer.shadowOpacity = 0
                }
                attr.frame = CGRect(x: 0, y: lastTotalHeight, width: collectionView.frame.width, height: height)
            })
        }
        
        if self.displayType == .horizontalCoverScroll {
            let currentPage = Int((collectionView.contentOffset.x / collectionView.frame.width).rounded(.down))
            self.currentPage = currentPage
            let rows = collectionView.numberOfItems(inSection: 0)
            let startIndex = max(0, currentPage - 1)
            let endIndex = min(rows - 1, currentPage + 1)
            var attrs = [UICollectionViewLayoutAttributes]()
            for index in startIndex...endIndex {
                let indexPath = IndexPath(item: index, section: 0)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if attr.indexPath.row == endIndex && collectionView.contentOffset.x >= 0 && collectionView.contentOffset.x <= collectionView.contentSize.width - collectionView.frame.width {
                    attr.zIndex = -1
                    attr.frame = CGRect(x: collectionView.contentOffset.x, y: 0, width: itemSize.width, height: itemSize.height)
                    if let cell = collectionView.cellForItem(at: indexPath) {
                        cell.layer.shadowOpacity = 0
                    }
                }
                else {
                    attr.zIndex = 1
                    attr.frame = CGRect(x: CGFloat(index) * itemSize.width, y: 0, width: itemSize.width, height: itemSize.height)
                    
                    if let cell = collectionView.cellForItem(at: indexPath){
                        cell.layer.shadowColor = UIColor.black.cgColor
                        cell.layer.shadowOffset = CGSize(width: 5, height: 0)
                        cell.layer.shadowOpacity = 0.4
                        cell.layer.shadowRadius = 5
                        let path = UIBezierPath(rect: CGRect(x: 20, y: 5, width: itemSize.width - 20, height: itemSize.height - 10))
                        cell.layer.shadowPath = path.cgPath
                        if attr.indexPath.row == rows - 1 {
                            cell.layer.shadowOpacity = 0
                        }
                    }
                }
                attrs.append(attr)
            }
            attributes = attrs
        }
        
        if self.displayType == .horizontalScroll {
            let currentPage = Int((collectionView.contentOffset.x / collectionView.frame.width).rounded(.down))
            self.currentPage = currentPage
            (attributes ?? []).forEach({ attr in
                if let cell = collectionView.cellForItem(at: attr.indexPath) {
                    cell.layer.shadowOpacity = 0
                }
            })
            
        }
        
        return attributes
    }
    
    func currentContentOffset(count: Int) -> CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        switch displayType {
        case .verticalScroll:
            let totalHeight = [Int](0...max(0, count - 1)).reduce(0.0) { result, pageNum in
                result + (dataSource?.heigtOfVerticalScrollPage(flowLayout: self, pageIndex: pageNum) ?? collectionView.frame.height)
            }
            return CGPoint(x: 0, y: totalHeight)
        default:
            let totalHeight = CGFloat(count) * itemSize.width
            return CGPoint(x: totalHeight, y: 0)
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
