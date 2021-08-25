//
//  SSReaderToolView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import UIKit

public class SSReaderToolView: UIView {
    lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
    var lineHeight: CGFloat = 0.5
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
  
    func makeUI() {
        addSubview(lineView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: 0, width: frame.width, height: lineHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


public class TintColorButton: UIButton {
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        if let image = self.currentImage {
            let image = image.tintColorImage(color: tintColor)
            setImage(image, for: .normal)
        }
    }
}


extension UIImage {
    func tintColorImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.set()
        UIRectFill(rect)
        draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
