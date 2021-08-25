//
//  SSReaderContentCell.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/7.
//

import UIKit

class SSReaderContentCell: UICollectionViewCell {
    private var _containerView: UIView? = nil
    var containerView: UIView? {
        set {
            if newValue != nil && _containerView == nil{
                _containerView = newValue
                contentView.addSubview(_containerView!)
                layoutIfNeeded()
            }
        }
        get {
            return _containerView
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _containerView?.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
