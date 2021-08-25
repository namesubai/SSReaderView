//
//  SSReaderEditView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/19.
//

import UIKit

/// 亮度
class SSReaderBrightSlider: UISlider, SSEventTrigger {
    enum Event {
        case valueDidChange(value: CGFloat)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    override func setValue(_ value: Float, animated: Bool) {
        super.setValue(value, animated: animated)
        UIScreen.main.brightness = CGFloat(value)
        if let trigger = self.triggerEvent {
            trigger(.valueDidChange(value: CGFloat(value)))
        }
    }
    
    func makeUI() {
        let color = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        thumbTintColor = color
        let image = UIImage(named: "read_edit_slide")
        setThumbImage(image, for: .normal)
        setThumbImage(image, for: .highlighted)
        minimumValueImage = UIImage(named: "read_edit_bright_min")
        maximumValueImage = UIImage(named: "read_edit_bright_max")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        self.layer.cornerRadius = 2.5 / 2
        return CGRect(x: 30, y: (bounds.height - 2.5)/2, width: bounds.width - 30 * 2, height: 2.5)
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        print(value)
        return CGRect(x: 30 + (bounds.width - 30 * 2 - 16) * CGFloat(value), y: (bounds.height - 16)/2, width: 16, height: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 字号
class SSReaderFontView: UIView, SSEventTrigger {
    enum Event {
        case fontSize(size: CGFloat)
    }
    var maxFontSize: CGFloat = 30
    var minFontSize: CGFloat = 15
    var currentFontSize: CGFloat = 15 {
        didSet {
            fontLabel.text = "\(Int(currentFontSize))"
            if currentFontSize != oldValue {
                if let trigger = self.triggerEvent {
                    trigger(.fontSize(size: currentFontSize))
                }
            }
        }
    }
    lazy var reduceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "read_edit_font_reduce")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 37 / 2
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return button
    }()
    
    lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "read_edit_font_increase")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 37 / 2
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return button
    }()
    
    lazy var fontLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    func makeUI() {
        addSubview(containerView)
        containerView.addArrangedSubview(reduceButton)
        containerView.addArrangedSubview(fontLabel)
        containerView.addArrangedSubview(increaseButton)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        reduceButton.snp.makeConstraints { make in
            make.width.equalTo(increaseButton.snp.width).priority(.high)
            make.height.equalTo(37)
        }
        increaseButton.snp.makeConstraints { make in
            make.height.equalTo(37)
        }
        fontLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        reduceButton.addTarget(self, action: #selector(reduceAction(button:)), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseAction(button:)), for: .touchUpInside)
        fontLabel.text = "\(Int(currentFontSize))"
    }
    
    @objc func reduceAction(button: UIButton) {
        if currentFontSize == minFontSize {
            return
        }
        currentFontSize -= 1
    }
    
    @objc func increaseAction(button: UIButton) {
        if currentFontSize == maxFontSize {
            return
        }
        currentFontSize += 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 行距
class SSReaderLineSpaceView: UIView, SSEventTrigger {
    
    enum Event {
        case chose(type: SSReaderCommon.SpaceType)
    }
        
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private var buttons = [UIButton]()
    let allTypes: [SSReaderCommon.SpaceType] = [.min, .meduim, .max]
    var currentType: SSReaderCommon.SpaceType = .min {
        didSet {
            let index = allTypes.firstIndex(of: currentType)
            let button = buttons[index!]
            button.sendActions(for: .touchUpInside)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    func makeUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        allTypes.forEach { type in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 37 / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            button.setImage(type.image?.withRenderingMode(.alwaysOriginal), for: .normal)
            containerView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(37)
            }
            buttons.append(button)
            if type == .min {
                button.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc func buttonAction(button: UIButton) {
        for btn in buttons {
            if btn == button {
                btn.layer.borderColor = UIColor.black.cgColor
                let index = buttons.firstIndex(of: btn)
                let type = allTypes[index!]
                if let trigger = self.triggerEvent {
                    trigger(.chose(type: type))
                }
            } else {
                btn.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 翻页方式
class SSReaderPageCurlTypeView: UIView, SSEventTrigger {
    
    enum Event {
        case chose(type: SSReaderCommon.PageCurlType)
    }
  
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    var currentType: SSReaderCommon.PageCurlType = .pageCurl {
        didSet {
            let index = allTypes.firstIndex(of: currentType)
            let button = buttons[index!]
            button.sendActions(for: .touchUpInside)
        }
    }
    
    private var buttons = [UIButton]()
    let allTypes: [SSReaderCommon.PageCurlType] = [.pageCurl, .horizontalScroll, .verticalScroll, .horizontalCoverScroll]

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    func makeUI() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        allTypes.forEach { type in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 37 / 2
            button.layer.borderWidth = 1
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            button.setTitle(type.title, for: .normal)
            let size = button.titleLabel!.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: 37))
            containerView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(37)
                make.width.equalTo(size.width + 30)
            }
            buttons.append(button)
            if type == .pageCurl {
                button.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc func buttonAction(button: UIButton) {
        for btn in buttons {
            if btn == button {
                btn.layer.borderColor = UIColor.black.cgColor
                let index = buttons.firstIndex(of: btn)
                let type = allTypes[index!]
                if let trigger = self.triggerEvent {
                    trigger(.chose(type: type))
                }
            } else {
                btn.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 主题颜色
class SSReaderThemeColorsView: UIView, SSEventTrigger {
    enum Event {
        case chose(color: SSReaderCommon.Colors)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        return stackView
    }()
    
    var currentType: SSReaderCommon.Colors = .white {
        didSet {
            let index = allTypes.firstIndex(of: currentType)
            let button = buttons[index!]
            button.sendActions(for: .touchUpInside)
        }
    }
    
    
    private var buttons = [UIButton]()
    let allTypes: [SSReaderCommon.Colors] = [.white, .yellow, .green, .pink, .blue, .dark]

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    func makeUI() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        allTypes.forEach { type in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 37 / 2
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.layer.borderColor = UIColor.black.cgColor
            button.backgroundColor = type.color
            containerView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(37)
            }
            buttons.append(button)
            if type == .white {
                button.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc func buttonAction(button: UIButton) {
        for btn in buttons {
            if btn == button {
                btn.layer.borderWidth = 1
                let index = buttons.firstIndex(of: btn)
                let type = allTypes[index!]
                if let trigger = self.triggerEvent {
                    trigger(.chose(color: type))
                }
            } else {
                btn.layer.borderWidth = 0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space = (frame.width - CGFloat(allTypes.count) * 37) / CGFloat(allTypes.count - 1)
        containerView.spacing = space
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// 编辑弹窗
class SSReaderEditView: UIView {

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var brightSlider: SSReaderBrightSlider = {
        let slider = SSReaderBrightSlider()
        return slider
    }()
    
    lazy var fontView: SSReaderFontView = {
        let view = SSReaderFontView()
        return view
    }()
    
    lazy var lineSpaceView: SSReaderLineSpaceView = {
        let view = SSReaderLineSpaceView()
        return view
    }()
    
    lazy var pageCurlTypeView: SSReaderPageCurlTypeView = {
        let view = SSReaderPageCurlTypeView()
        return view
    }()
    
    lazy var colorView: SSReaderThemeColorsView = {
        let view = SSReaderThemeColorsView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    func makeUI() {
        backgroundColor = .white
        addSubview(lineView)
        addSubview(brightSlider)
        addSubview(fontView)
        addSubview(lineSpaceView)
        addSubview(pageCurlTypeView)
        addSubview(colorView)

        lineView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        brightSlider.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(20)
        }
        
        fontView.snp.makeConstraints { make in
            make.top.equalTo(brightSlider.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(37)
        }
        
        lineSpaceView.snp.makeConstraints { make in
            make.top.equalTo(fontView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(37)
        }
        
        pageCurlTypeView.snp.makeConstraints { make in
            make.top.equalTo(lineSpaceView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(37)
        }
        
        colorView.snp.makeConstraints { make in
            make.top.equalTo(pageCurlTypeView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(37)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
