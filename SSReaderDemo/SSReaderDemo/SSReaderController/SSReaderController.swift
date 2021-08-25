//
//  SSReaderController.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import UIKit
import SSAlertSwift
import SSReaderView


public class SSReaderController: UIViewController {

    public lazy var topToolView: SSReaderTopToolView = {
        let view = SSReaderTopToolView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44 + UIApplication.shared.statusBarFrame.height))
        return view
    }()
    
    
    public lazy var bottomToolView: SSReaderBottomToolView = {
        let view = SSReaderBottomToolView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 55 + SSReaderCommon.safeAreaInsets.bottom))
        return view
    }()
    
    
    public lazy var readerView: SSReaderView = {
        let readerView = SSReaderView()
        return readerView
    }()
    
    var chapterPages = [ChapterPage]()
    var book: Book!
    var currentChapterNum: Int = 0

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        makeUI()
        transitionToPage()
        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func loadData() {
        let fontSize = SSReaderManager.shared.fontValue.currentType
        let lineSapce = SSReaderManager.shared.lineSpaceType.currentType
        book = SSReaderManager.shared.encodeTextFile(font: UIFont.systemFont(ofSize: fontSize), lineSapce: lineSapce.mulitiple * 15, size: CGSize(width: view.frame.width - 16 * 2, height: view.frame.height - 40 * 2))
        chapterPages = book.chapters.reduce([], { result, chapter in
            result + chapter.pages
        })
    }
    
    func transitionToPage(rangeLocation: Int? = nil) {
        var rangeLoc = SSReaderManager.shared.readProgress.currentType
        if rangeLocation != nil {
            rangeLoc = rangeLocation!
        }
        if let pageNum = chapterPages.firstIndex(where: { chapterPage in
            let chapter = self.book.chapters[chapterPage.chapterSort - 1]
            let chapterRange = chapter.range
            let range = NSMakeRange(chapterRange.location + chapterPage.range.location, chapterPage.range.length)
            return range.contains(rangeLoc)
        }) {
            readerView.transitionToPage(pageNum: pageNum + 1)
        }
    }
    
    func makeUI() {
        
        readerView.delegate = self
        readerView.dataSource = self
        readerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        readerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(readerView)
        
        readerView.register(contentView: SSReaderContentView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderContentView.self))
        readerView.register(contentView: SSReaderCoverView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderCoverView.self))
        readerView.register(contentView: SSReaderEndView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderEndView.self))
        readerView.reloadData()
        
        topToolView.trigger { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .back:
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        bottomToolView.trigger { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .chapterList:
                self.showChapterListView()
            case .settings:
                self.showEditView()
            case .darkAndLight:
                if SSReaderManager.shared.themeType.currentType != .dark {
                    SSReaderManager.shared.themeType.currentType = .dark
                } else {
                    SSReaderManager.shared.themeType.currentType = .white
                }
            }
        }
        
        SSReaderManager.shared.themeType.observeChange { [weak self] theme in
            guard let self = self else { return }
            self.readerView.backgroundColor = theme.contentBackgroudColor
            self.topToolView.backgroundColor = theme.toolBackgroudColor
            self.bottomToolView.backgroundColor = theme.toolBackgroudColor
            self.topToolView.lineView.backgroundColor = theme.toolLineColor
            self.bottomToolView.lineView.backgroundColor = theme.toolLineColor
            self.topToolView.backButton.tintColor = theme.toolControlTextColor
            self.bottomToolView.chapterListButton.tintColor = theme.toolControlTextColor
            self.bottomToolView.settingsButton.tintColor = theme.toolControlTextColor
            self.bottomToolView.lightModeButton.tintColor = theme.toolControlTextColor
            self.readerView.reloadData()
        }
        
        SSReaderManager.shared.pageCurlTypeType.observeChange { [weak self] type in
            guard let self = self else { return }
            self.readerView.switchReaderDisplayType(type)
        }
        
        SSReaderManager.shared.fontValue.observeChange { [weak self] _ in
            guard let self = self else { return }
            self.loadData()
            self.readerView.reloadData()
        }
        
        SSReaderManager.shared.lineSpaceType.observeChange { [weak self] _ in
            guard let self = self else { return }
            self.loadData()
            self.readerView.reloadData()
        }
    }
   
    func showChapterListView() {
        
        let chapterListVC = SSChapterListController(chapters: self.book.chapters, currentChapterNum: currentChapterNum)
        chapterListVC.view.ss_w = view.frame.width * 0.8
        chapterListVC.view.ss_h = view.frame.height
        
        let alertView = SSAlertView(customView: chapterListVC.view, fromViewController: self, canPanDimiss: false)
        let animation = SSAlertDefaultAnmation(state: .fromLeft)
        animation.isSpringShowAnimation = false
        alertView.animation = animation
        alertView.show()
        
        chapterListVC.selectedChapter { [weak alertView, weak self] number in
            guard let self = self else { return }
            let chapter = self.book.chapters[number]
            self.transitionToPage(rangeLocation: chapter.range.location)
            alertView?.hide()
        }
    }
    
    func showEditView() {
        let customView = SSReaderEditView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        customView.brightSlider.setValue(Float(SSReaderManager.shared.brightValue.currentType), animated: false)
        customView.fontView.currentFontSize = SSReaderManager.shared.fontValue.currentType
        customView.lineSpaceView.currentType = SSReaderManager.shared.lineSpaceType.currentType
        customView.pageCurlTypeView.currentType = SSReaderManager.shared.pageCurlTypeType.currentType
        customView.colorView.currentType = SSReaderManager.shared.themeType.currentType
        
        let alertView = SSAlertView(customView: customView, fromViewController: self, animation: SSAlertDefaultAnmation(state: .fromBottom), canPanDimiss: false)
        alertView.show()
        
        customView.brightSlider.trigger { event in
            switch event {
            case .valueDidChange(let value):
                SSReaderManager.shared.brightValue.currentType = value
            }
        }
        
        customView.fontView.trigger { event in
            switch event {
            case .fontSize(let size):
                SSReaderManager.shared.fontValue.currentType = size
            }
        }
        
        customView.lineSpaceView.trigger { event in
            switch event {
            case .chose(let type):
                SSReaderManager.shared.lineSpaceType.currentType = type
            }
        }
        
        customView.pageCurlTypeView.trigger { event in
            switch event {
            case .chose(let type):
                SSReaderManager.shared.pageCurlTypeType.currentType = type
            }
        }
        
        customView.colorView.trigger { event in
            switch event {
            case .chose(let type):
                SSReaderManager.shared.themeType.currentType = type
            }
        }
    }
}


extension SSReaderController: SSReaderDataSource, SSReaderDelegate {
    public func pageCountOfReaderView(readerView: SSReaderView) -> Int {
        chapterPages.count + 1 + 1
    }
    
    public func pageContentView(readerView: SSReaderView, pageNum: Int) -> UIView {
        if pageNum == 0 {
            let contentView = readerView.dequeueReusableContentView(withReuseIdentifier: NSStringFromClass(SSReaderCoverView.self), for: pageNum) as!  SSReaderCoverView
            contentView.backgroundColor = SSReaderManager.shared.themeType.currentType.value.contentBackgroudColor
            contentView.textLabel.text = book.desc
            contentView.textLabel.textColor = SSReaderManager.shared.themeType.currentType.value.contentTextColor

            return contentView
        } else if pageNum == pageCountOfReaderView(readerView: readerView) - 1 {
            let contentView = readerView.dequeueReusableContentView(withReuseIdentifier: NSStringFromClass(SSReaderEndView.self), for: pageNum)
            contentView.backgroundColor = SSReaderManager.shared.themeType.currentType.value.contentBackgroudColor
            return contentView
        }
        
        let chapter = chapterPages[pageNum - 1]
        
        let contentView = readerView.dequeueReusableContentView(withReuseIdentifier: NSStringFromClass(SSReaderContentView.self), for: pageNum) as! SSReaderContentView
        contentView.textLabel.textColor = SSReaderManager.shared.themeType.currentType.value.contentTextColor
        contentView.pageNumLabel.textColor = SSReaderManager.shared.themeType.currentType.value.contentTextColor
        contentView.backgroundColor = SSReaderManager.shared.themeType.currentType.value.contentBackgroudColor
        contentView.textLabel.attributedText = chapter.attrContent
        contentView.pageNumLabel.text = "\(pageNum) / \(chapterPages.count)"
        return contentView
    }
    
    public func pageNum(readerView: SSReaderView, pageNum: Int) {
        if pageNum > 0 {
            if chapterPages.count > pageNum - 1 {
                let chapterPage = chapterPages[pageNum - 1]
                let chapter = book.chapters[chapterPage.chapterSort - 1]
                let chapterRange = chapter.range
                let rangeLoc = chapterRange.location + chapterPage.range.location
                SSReaderManager.shared.readProgress.currentType = rangeLoc
                currentChapterNum = chapterPage.chapterSort - 1
            }
            
        }
        
    }
    
    public func topToolView(readerView: SSReaderView) -> UIView? {
        return topToolView
    }
    
    public func bottomToolView(readerView: SSReaderView) -> UIView? {
        return bottomToolView
    }
}


