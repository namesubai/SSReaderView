//
//  SSReaderCoverView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/11.
//

import UIKit

class SSReaderCoverView: UIView {
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    lazy var imageV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "cover")
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageV)
        addSubview(textLabel)
        
        imageV.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 88 * 1.5, height: 120 * 1.5))
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(imageV.snp.bottom).offset(20)
            make.bottom.equalTo(-30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
