//
//  SSReaderManager.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/20.
//

import UIKit

struct Book {
    var desc: String?
    var chapters: [Chapter]
}

struct Chapter {
    /// 第几章
    var sort: Int
    /// 章节名称
    var title: String?
    /// 划分了多少页
    var pageCount: Int
    /// 内容
    var content: String
    /// 分页
    var pages: [ChapterPage]

    /// 文字的长度
    var range: NSRange
}

struct ChapterPage {
    /// 第几章
    var chapterSort: Int
    /// 第几页
    var pageNum: Int
    /// 内容
    var content: String
    /// 内容
    var attrContent: NSAttributedString
    /// 文字的长度
    var range: NSRange
}


extension SSReaderManager {
    static let themeTypeKey = "themeType.key"
    static let brightValueKey = "brightValue.key"
    static let fontValueKey = "fontValue.key"
    static let lineSpaceKey = "lineSpace.key"
    static let pageCurlTypeKey = "pageCurlType.key"
    static let readProgressKey = "readProgress.key"
}

typealias BrightValue = CGFloat
extension BrightValue: SSReaderObserverType {
    var cachesValue: CGFloat {
        return self
    }
    var value: CGFloat {
        return self
    }
    
    func transform(value: Any?) -> BrightValue {
        return (value as? BrightValue) ?? self
    }
}

extension Int: SSReaderObserverType {
    var cachesValue: Int {
        return self
    }
    var value: Int {
        return self
    }
    
    func transform(value: Any?) -> Int {
        return (value as? Int) ?? self
    }
}

class SSReaderManager: NSObject {
    static let shared = SSReaderManager()
    let themeType = SSReaderObserver(key: SSReaderManager.themeTypeKey, defaultType: SSReaderCommon.Colors.white)
    let brightValue = SSReaderObserver(key: SSReaderManager.brightValueKey, defaultType: UIScreen.main.brightness)
    let fontValue = SSReaderObserver(key: SSReaderManager.fontValueKey, defaultType: CGFloat(15.0))
    let lineSpaceType = SSReaderObserver(key: SSReaderManager.lineSpaceKey, defaultType: SSReaderCommon.SpaceType.min)
    let pageCurlTypeType = SSReaderObserver(key: SSReaderManager.pageCurlTypeKey, defaultType: SSReaderCommon.PageCurlType.pageCurl)
    let readProgress = SSReaderObserver(key: SSReaderManager.readProgressKey, defaultType: 0)

}

protocol SSReaderObserverType {
    associatedtype Value
    associatedtype CacheValue
    associatedtype CurrentType
    var cachesValue: CacheValue { get }
    var value: Value { get }
    func transform(value: Any?) -> CurrentType
}



class SSReaderObserver<CurrentType> where CurrentType: SSReaderObserverType {
    private var _currentType: CurrentType? = nil
    private var key: String
    private var defaultType: CurrentType
    typealias Observer = ((CurrentType.Value) -> Void)
    private var observers = [WeakObserver<Observer>]()
    var currentType: CurrentType {
        get {
            if _currentType != nil {
                return _currentType!
            } else {
                _currentType = (self.defaultType.transform(value: UserDefaults.standard.object(forKey: key)) as? CurrentType) ?? self.defaultType
                return _currentType!
            }
        }
        set {
            _currentType = newValue
            UserDefaults.standard.set(newValue.cachesValue, forKey: key)
            UserDefaults.standard.synchronize()
            observers.forEach { observer in
                if let observer = observer.observer?.observer {
                    observer(_currentType!.value)
                }
            }

        }
    }
    
    init(key: String, defaultType: CurrentType) {
        self.key = key
        self.defaultType = defaultType
    }
    
    func observeChange(onNext: Observer?) {
        if let onNext = onNext {
            onNext(currentType.value)
            observers.append(WeakObserver(observer: onNext))
        }
    }
}


private class WeakObserver<T> {
    class _Observer<T>: NSObject {
        var observer: T
        init(observer: T) {
            self.observer = observer
            super.init()
        }
    }
    
    weak var observer: _Observer<T>?
    private var _strongObserver: _Observer<T>?
    init(observer: T) {
         let t = _Observer(observer: observer)
        _strongObserver = t
        self.observer = _strongObserver
    }
}



extension SSReaderManager {
    func encodeTextFile(font: UIFont, lineSapce: CGFloat, size: CGSize) -> Book {
        let decodeString = String.encodeTextFile(url: URL(fileURLWithPath: Bundle.main.path(forResource: "宠她", ofType: ".txt")!))
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        var chapters = [Chapter]()
        var desc: String?
        if let expression = try? NSRegularExpression(pattern: parten, options: .caseInsensitive) {
            let results = expression.matches(in: decodeString, options: .reportCompletion, range: NSMakeRange(0, decodeString.count))
            var startCount = -1
            var lastTitle: String?
            for result in results {
                let index = results.firstIndex(of: result)
                let range = result.range
               
                if startCount != -1 && index! > 0 {
                    let contentRange = NSMakeRange(startCount, range.location - startCount)

                    let content = decodeString.substring(with: Range(contentRange, in: decodeString)!)
                    let pages = chapterPages(content: content, font: font, lineSapce: lineSapce, size: size, chapterSort: index!)
                    let chapter = Chapter(sort: index!,title: lastTitle, pageCount: pages.count, content: String(content), pages: pages, range: contentRange)
                    chapters.append(chapter)
                    if index == results.count - 1 {
                        let contentRange = NSMakeRange(range.location, decodeString.count - range.location)
                        let content = decodeString.substring(with: Range(contentRange, in: decodeString)!)
                        let title = decodeString.substring(with: Range(range, in: decodeString)!)
                        let pages = chapterPages(content: content, font: font, lineSapce: lineSapce, size: size, chapterSort: index!)
                        let chapter = Chapter(sort: index! + 1, title: title, pageCount: pages.count, content: String(content), pages: pages, range: contentRange)
                        chapters.append(chapter)
                    }
                }
                startCount = range.location
                lastTitle = decodeString.substring(with: Range(range, in: decodeString)!)
                if index == 0 && range.location > 0 {
                    desc = decodeString.substring(with: Range(NSMakeRange(0, range.location), in: decodeString)!)
                }
            }
        }
        return Book(desc: desc, chapters: chapters)
    }
    
    func chapterPages(content: String, font: UIFont, lineSapce: CGFloat, size: CGSize, chapterSort: Int) -> [ChapterPage] {
        let attrString = NSMutableAttributedString(string: content)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSapce
        attrString.addAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, content.count))
        let pageRanges = attrString.pageRanges(size: size)
        let pages = pageRanges.map({
            pageRange -> ChapterPage in
            let pageContent = content.substring(with: Range(pageRange, in: content)!)
            let pageAttrContent = attrString.attributedSubstring(from: pageRange)
            return ChapterPage(chapterSort: chapterSort, pageNum: pageRanges.firstIndex(of: pageRange)!, content: pageContent, attrContent: pageAttrContent, range: pageRange)
        })
        
        return pages
    }
}
