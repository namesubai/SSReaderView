//
//  SSReaderBottomToolView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import UIKit

public class SSReaderBottomToolView: SSReaderToolView, SSEventTrigger {
    enum Event {
        case chapterList, settings, darkAndLight
    }
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var chapterListButton: TintColorButton = {
        let button = TintColorButton(type: .system)
        button.setImage(UIImage(named: "read_edit_chapterlist")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addSubview(button)
        button.addTarget(self, action: #selector(chapterListAction), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: TintColorButton = {
        let button = TintColorButton(type: .system)
        button.setImage(UIImage(named: "read_edit_font")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addSubview(button)
        button.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        return button
    }()
    
    
    lazy var lightModeButton: TintColorButton = {
        let button = TintColorButton(type: .system)
        button.setImage(UIImage(named: "read_edit_night")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addSubview(button)
        button.addTarget(self, action: #selector(lightAndDarkModeAction), for: .touchUpInside)
        return button
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubview(containerView)
        containerView.addArrangedSubview(chapterListButton)
        containerView.addArrangedSubview(settingsButton)
        containerView.addArrangedSubview(lightModeButton)

        containerView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(0)
            make.right.equalTo(-16)
            make.bottom.equalTo(-SSReaderCommon.safeAreaInsets.bottom)
        }
        
    }
    
    @objc private func chapterListAction() {
        if let trigger = self.triggerEvent  {
            trigger(.chapterList)
        }
    }
    
    @objc private func settingsAction() {
        if let trigger = self.triggerEvent  {
            trigger(.settings)
        }
    }
    
    @objc private func lightAndDarkModeAction() {
        if let trigger = self.triggerEvent  {
            trigger(.darkAndLight)
        }
    }
}
