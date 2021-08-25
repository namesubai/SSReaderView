//
//  SSReaderEndView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/11.
//

import UIKit

class SSReaderEndView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let textLabel = UILabel()
        textLabel.text = "结束页"
        textLabel.backgroundColor = .red
        textLabel.textAlignment = .center
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
