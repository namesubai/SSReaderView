//
//  SSReaderCommon.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/11.
//

import Foundation
import UIKit
import CoreText
import SSReaderView

struct SSReaderCommon {
    static var safeAreaInsets: UIEdgeInsets = {
        guard #available(iOS 11.0, *) else {
            return .zero
        }
        return UIApplication.shared.windows[0].safeAreaInsets
    }()
    
}

extension SSReaderCommon {
    enum SpaceType: Int, SSReaderObserverType {
        case min = 0
        case meduim
        case max
        var mulitiple: CGFloat {
            switch self {
            case .min: return 1.6
            case .meduim: return 2.0
            case .max: return 3.0
            }
        }
        
        var image: UIImage? {
            switch self {
            case .min:
               return UIImage(named: "read_edit_textSpace_3")
            case .meduim:
               return UIImage(named: "read_edit_textSpace_2")
            case .max:
               return UIImage(named: "read_edit_textSpace_1")
            }
        }
        
        var cachesValue: Int {
            return rawValue
        }
        var value: CGFloat {
            return mulitiple
        }
        func transform(value: Any?) -> SSReaderCommon.SpaceType {
            guard let value = value as? Int else {
                return self
            }
            return  SSReaderCommon.SpaceType(rawValue: value) ?? self
        }
    }
}

extension SSReaderCommon {
    enum PageCurlType: Int, SSReaderObserverType {
        case pageCurl
        case horizontalScroll
        case verticalScroll
        case horizontalCoverScroll
        
        var title: String {
            switch self {
            case .pageCurl:
               return "仿真"
            case .horizontalScroll:
               return "左右滑动"
            case .verticalScroll:
               return "上下滚动"
            case .horizontalCoverScroll:
               return "左右覆盖"
            }
        }
        
        var cachesValue: Int {
            return rawValue
        }
        var value: SSReaderView.DisplayType {
            switch self {
            case .pageCurl:
                return SSReaderView.DisplayType.pageCurl
            case .horizontalScroll:
                return SSReaderView.DisplayType.horizontalScroll
            case .verticalScroll:
                return SSReaderView.DisplayType.verticalScroll
            case .horizontalCoverScroll:
                return SSReaderView.DisplayType.horizontalCoverScroll
            }
        }
        
        func transform(value: Any?) -> SSReaderCommon.PageCurlType {
            guard let value = value as? Int else {
                return self
            }
            return  SSReaderCommon.PageCurlType(rawValue: value) ?? self
        }
    }
}

extension SSReaderCommon {
    
    enum Colors: Int, SSReaderObserverType{
        
        case white, dark, pink, yellow, green, blue
        var value: SSReaderTheme {
            switch self {
            case .white:
                return whiteTheme
            case .dark:
                return darkTheme
            case .pink:
                return pinkTheme
            case .yellow:
                return yellowTheme
            case .green:
                return greenTheme
            case .blue:
                return blueTheme
            }
        }
        var cachesValue: Int {
            rawValue
        }
        
        var color: UIColor {
            switch self {
            case .white:
                return UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1)
            case .yellow:
                return UIColor(red: 0.89, green: 0.87, blue: 0.79, alpha: 1)
            case .green:
                return UIColor(red: 0.87, green: 0.91, blue: 0.82, alpha: 1)
            case .pink:
                return UIColor(red: 1, green: 0.89, blue: 0.91, alpha: 1)
            case .blue:
                return UIColor(red: 0.8, green: 0.84, blue: 0.89, alpha: 1)
            case .dark:
                return UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
            }
        }
        
        func transform(value: Any?) -> SSReaderCommon.Colors {
            guard let value = value as? Int else {
                return self
            }
            return  SSReaderCommon.Colors(rawValue: value) ?? self
        }
    }
    static let whiteTheme = WhiteTheme()
    static let darkTheme = DarkTheme()
    static let pinkTheme = PinkTheme()
    static let yellowTheme = YellowTheme()
    static let greenTheme = GreenTheme()
    static let blueTheme = BlueTheme()
   
}


extension NSAttributedString {
    func pageRanges(size: CGSize) -> [NSRange] {
        var ranges = [NSRange]()
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        let path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        var range = CFRangeMake(0, 0)
        var loc = 0
        while range.location + range.length < length {
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(loc, 0), path, nil)
            range = CTFrameGetVisibleStringRange(frame)
            ranges.append(NSMakeRange(loc, range.length))
            loc += range.length
        }
        return ranges
    }
}


extension String {
    static func encodeTextFile(url: URL?) -> String {
        var content: String? = nil
        guard let url = url else {
            return content ?? ""
        }
        content = try? NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String
        if content == nil {
            content = try? NSString(contentsOf: url, encoding: 0x80000632) as String
        }
        if content == nil {
            content = try? NSString(contentsOf: url, encoding: 0x80000631) as String
        }
        return content ?? ""
    }
}
