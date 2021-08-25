# SSReaderView

使用Swift编写，底层是使用collectView和pageviewcontroller封装的一个阅读器小组件，界面复用，不用考虑内存问题，demo是整个阅读器的实现，基本满足大部分阅读器的需求。
你也可以通过 **CocoaPods**(pod 'SSReaderView') 安装 **SSReaderView** ,自己自定义阅读器。

# 特性
- 支持类似tabelView或者collectionview那样自定义每一页，上下滚动还支持修改每一页的size
- 支持仿真、左右滑动、上下滑动、左右覆盖翻页
- 支持亮度、字体、行距、背景颜色修改
- 支持自定义上、下工具栏
- 界面复用，不用考虑内存问题
# 效果图
<img src="https://github.com/namesubai/SSReaderView/blob/main/demo.gif" />

# SSReaderView的使用

初始化
```
/// 代理和注册
readerView.delegate = self
readerView.dataSource = self
readerView.register(contentView: SSReaderContentView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderContentView.self))
readerView.register(contentView: SSReaderCoverView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderCoverView.self))
readerView.register(contentView: SSReaderEndView.self, contentViewWithReuseIdentifier: NSStringFromClass(SSReaderEndView.self))
readerView.reloadData()

/// 代理方法
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
    /// 上工具栏
    public func topToolView(readerView: SSReaderView) -> UIView? {
        return topToolView
    }
    /// 下工具栏
    public func bottomToolView(readerView: SSReaderView) -> UIView? {
        return bottomToolView
    }
}
```


# Demo说明
[SSReaderManager:](https://github.com/namesubai/SSReaderView/blob/main/SSReaderDemo/SSReaderDemo/SSReaderController/SSReaderManager.swift)
- 本地.txt的解码和转换model
- 亮度、字体、行距、背景颜色、翻页的存储
- 支持全局监听修改进行刷新UI

