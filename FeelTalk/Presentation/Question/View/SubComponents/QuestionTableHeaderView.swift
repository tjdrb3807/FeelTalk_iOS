//
//  QuestionTableHeaderView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import UIKit
import SnapKit

final class QuestionTableHeaderView: UITableViewHeaderFooterView {
    // MARK: SubComponents
    private lazy var questionIndexLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableHeaderViewNameSpace.questionIndexLabelText
        label.textAlignment = .center
        label.textColor = UIColor(named: QuestionTableHeaderViewNameSpace.questionIndexLabelTextColor)
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionIndexLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.questionIndexLabelTextSize)
        label.backgroundColor = UIColor(named: QuestionTableHeaderViewNameSpace.questionIndexLabelBackgroundColor)
        label.layer.cornerRadius = QuestionTableHeaderViewNameSpace.questionIndexLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var newSignalLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableHeaderViewNameSpace.newSignalLabelText
        label.textColor = .white
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.newSignalLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.newSignalLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableHeaderViewNameSpace.questionHeaderLabelText
        label.textColor = .white
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.questionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionBodyLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableHeaderViewNameSpace.questionBodyLabelText
        label.textColor = .white
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.questionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionAnswerButton: UIButton = {
        let button = UIButton()
        button.setTitle(QuestionTableHeaderViewNameSpace.questionAnswerButtonNormalTitleText, for: .normal)
        button.setTitle(QuestionTableHeaderViewNameSpace.questionAnswerButtonSelectedTitleText, for: .selected)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionAnswerButtonTitleTextFont,
                                         size: QuestionTableHeaderViewNameSpace.questionAnswerButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = QuestionTableHeaderViewNameSpace.questionAnswerButtonCornerRadius
        button.clipsToBounds =  true
        
        return button
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: QuestionTableHeaderViewNameSpace.backgroundImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: QuestionTableHeaderViewNameSpace.contentViewTopEdegeInset,
                                                                     left: QuestionTableHeaderViewNameSpace.contentViewLeftEdegeInset,
                                                                     bottom: QuestionTableHeaderViewNameSpace.contentViewBottomEdegeInset,
                                                                     right: QuestionTableHeaderViewNameSpace.contentViewRightEdegeInset))
    }
    
    private func setAttributes() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: QuestionTableHeaderViewNameSpace.backgroundColor)
        contentView.layer.cornerRadius = QuestionTableHeaderViewNameSpace.corderRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        [backgroundImageView,
         questionIndexLabel,
         newSignalLabel,
         questionHeaderLabel,
         questionBodyLabel,
         questionAnswerButton].forEach { contentView.addSubview($0) }
    }
    
    private func setConfigurations() {
        makeQuestionIndexLabelConstraints()
        makeNewSignalLabelConstraints()
        makeQuestionHeaderLabelConstraints()
        makeQuestionBodyLabelConstraints()
        makeQuestionAnswerButtonConstraints()
        makeBackgroundImageViewConstraints()
    }
}

extension QuestionTableHeaderView {
    private func makeQuestionIndexLabelConstraints() {
        questionIndexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.questionIndexLabelTopInset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.questionIndexLabelLeadingInset)
            $0.width.height.equalTo(QuestionTableHeaderViewNameSpace.questionIndexLabelHeight)
        }
    }
    
    private func makeNewSignalLabelConstraints() {
        newSignalLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.newSignalLabelTrailingInset)
            $0.centerY.equalTo(questionIndexLabel)
        }
    }
    
    
    private func makeQuestionHeaderLabelConstraints() {
        questionHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(questionIndexLabel.snp.bottom).offset(QuestionTableHeaderViewNameSpace.questionHeaderLabelTopOffset)
            $0.leading.equalTo(questionIndexLabel)
            $0.height.equalTo(QuestionTableHeaderViewNameSpace.questionLabelHeight)
        }
    }
    
    private func makeQuestionBodyLabelConstraints() {
        questionBodyLabel.snp.makeConstraints {
            $0.top.equalTo(questionHeaderLabel.snp.bottom)
            $0.leading.equalTo(questionHeaderLabel.snp.leading)
            $0.height.equalTo(QuestionTableHeaderViewNameSpace.questionLabelHeight)
        }
    }
    
    private func makeQuestionAnswerButtonConstraints() {
        questionAnswerButton.snp.makeConstraints {
            $0.top.equalTo(questionBodyLabel.snp.bottom).offset(QuestionTableHeaderViewNameSpace.questionAnswerButtonTopOffset)
            $0.leading.equalTo(questionIndexLabel)
            $0.width.equalTo(QuestionTableHeaderViewNameSpace.questionAnswerButtonWidth)
            $0.height.equalTo(QuestionTableHeaderViewNameSpace.questionAnswerButtonHeight)
        }
    }
    
    private func makeBackgroundImageViewConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionTableHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTableHeaderView_Presentable()
    }
    
    struct QuestionTableHeaderView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionTableHeaderView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
