//
//  SSReaderTopToolView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import UIKit
import SnapKit



public class SSReaderTopToolView: SSReaderToolView,SSEventTrigger {
    
    
    enum Event {
        case back
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight)
    }
    
    lazy var backButton: TintColorButton = {
        let backButton = TintColorButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return backButton
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubview(backButton)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(50)
        }
    }
    
    @objc private func backAction() {
        if let trigger = self.triggerEvent {
            trigger(.back)
        }
    }
}
