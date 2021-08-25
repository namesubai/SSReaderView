//
//  SSReaderContentView.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/11.
//

import UIKit

class SSReaderContentView: UIView {
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    lazy var pageNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        addSubview(pageNumLabel)

        textLabel.text =  """
孩子为了不进职校，压力之大，我甚至听说，有初三学生晚上八点睡觉，凌晨两点起床读书做作业，忙到天亮，吃好早饭赶往学校。
            
            平心静气地讲，一个孩子如果不是读书的料，完全可以去职校学一门手艺。但家长却有三重焦虑：

            第一，一个普通高校的学生可以轻松去读职校的课程，但职校学生要去读普通高校的课程，难上加难。同一年级的各类学校和专业，在学习上是有难易梯度的。家长多不会同意让孩子一开始就选择容易的学校和专业，否则在未来竞争中，将处于不利地位。

            第二，初中毕业生社会经验匮乏，实际上根本没有能力做人生规划。选择职校学一门技术，同时也就意味着，将来从事其他工作的门槛是很高的。如果没有继续学习的能力，改行的成本之高，难以想象。

            以我的个人经验来讲，初中阶段，一度想去学习屠宰的手艺，毕业时也有上建筑类职高的机会，但都没去，在普通高中混到高三才决定考大学，如果去上职高，很可能就是个小包工头。我不知道这是不是我的真实意愿，但我觉得当下的工作更符合秉性。

            第三，中国的一些职校，风评并不十分好，家长并不十分放心把十五六岁的孩子送入这些学校，他们不担心孩子学艺不成，而是担心孩子“学坏了”。

            并且，随着科技加速进步，很多好端端的传统职业，忽然消失了。以汽修为例，现在的汽修专业毕业生，谁能保证他的精湛技术在10年之后不会归零？一些新职业出现没几年又消失了，谁能保证中高职教育能够跟上科技潮流？
"""
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 40, left: 16, bottom: 40, right: 16))
        }
        pageNumLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.right.equalTo(-30)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
