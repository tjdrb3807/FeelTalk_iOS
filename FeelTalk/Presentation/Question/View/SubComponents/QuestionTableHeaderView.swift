//
//  QuestionTableHeaderView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionTableHeaderView: UITableViewHeaderFooterView {
    let model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var spacingView: UIView = { UIView() }()
    
    private lazy var todayQuestionView: UIView = {
        let view  = UIView()
        view.backgroundColor = UIColor(named: QuestionTableHeaderViewNameSpace.todayQuestionViewBackgroundColor)
        view.layer.cornerRadius = QuestionTableHeaderViewNameSpace.todayQuestionViewCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var questionIndexLabel: UILabel = {
        let label = UILabel()
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
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.questionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionBodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.questionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var questionAnswerButton: UIButton = {
        let button = UIButton()
        button.setTitle(QuestionTableHeaderViewNameSpace.questionAnswerButtonBaseTitleText,
                        for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: QuestionTableHeaderViewNameSpace.questionAnswerButtonTitleTextFont,
                                         size: QuestionTableHeaderViewNameSpace.questionAnswerButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = QuestionTableHeaderViewNameSpace.qusetionAnswerButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: QuestionTableHeaderViewNameSpace.backgroundImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableHeaderViewNameSpace.sectionHeaderLabelText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: QuestionTableHeaderViewNameSpace.sectionHeaderLabelTextFont,
                            size: QuestionTableHeaderViewNameSpace.sectionHeaderLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.setUpData()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        setUpData()
    }
    
    private func addSubComponents() {
        addQuestionTableViewSubComponents()
        addTodayQuestionViewSubComponents()
    }
    
    private func setConfigurations() {
        makeSpacingViewConstraints()
        makeTodayQuestionViewConstraints()
        makeQuestionIndexLabelConstraints()
        makeNewSignalLabelConstraints()
        makeQuestionHeaderLabelConstraints()
        makeQuestionBodyLabelConstraints()
        makeQuestionAnswerButtonConstraints()
        makeBackgroundImageViewConstraints()
        makeSectionHeaderLabelConstraints()
    }
}

// MARK: UI setting method
extension QuestionTableHeaderView {
    private func addQuestionTableViewSubComponents() {
        [spacingView, todayQuestionView, sectionHeaderLabel].forEach { addSubview($0) }
    }
    
    private func makeSpacingViewConstraints() {
        spacingView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(spacingView.snp.top).offset(QuestionTableHeaderViewNameSpace.spacingViewHeight)
        }
    }
    
    private func makeTodayQuestionViewConstraints() {
        todayQuestionView.snp.makeConstraints {
            $0.top.equalTo(spacingView.snp.bottom).offset(QuestionTableHeaderViewNameSpace.todayQuestionViewTopOffset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.todayQuestionViewLeadingInset)
            $0.trailing.equalTo(todayQuestionView.snp.leading).offset(QuestionTableHeaderViewNameSpace.todqyQuestionViewWidth)
            $0.bottom.equalTo(todayQuestionView.snp.top).offset(QuestionTableHeaderViewNameSpace.todayQuestionViewHeight)
        }
    }
    
    private func addTodayQuestionViewSubComponents() {
        [backgroundImageView,
         questionIndexLabel, newSignalLabel,
         questionHeaderLabel, questionBodyLabel,
        questionAnswerButton].forEach { todayQuestionView.addSubview($0) }
    }
    
    private func makeQuestionIndexLabelConstraints() {
        questionIndexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.questionIndexLabelTopInset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.questionIndexLabelLeadingInset)
            $0.trailing.equalTo(questionIndexLabel.snp.leading).offset(QuestionTableHeaderViewNameSpace.questionIndexLabelWidth)
            $0.bottom.equalTo(questionIndexLabel.snp.top).offset(QuestionTableHeaderViewNameSpace.questionIndexLabelHeight)
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
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.questionHeaderLabelLeadingInset)
            $0.bottom.equalTo(questionHeaderLabel.snp.top).offset(QuestionTableHeaderViewNameSpace.questionLabelHeight)
        }
    }
    
    private func makeQuestionBodyLabelConstraints() {
        questionBodyLabel.snp.makeConstraints {
            $0.top.equalTo(questionHeaderLabel.snp.bottom)
            $0.leading.equalTo(questionHeaderLabel)
            $0.bottom.equalTo(questionBodyLabel.snp.top).offset(QuestionTableHeaderViewNameSpace.questionLabelHeight)
        }
    }
    
    private func makeQuestionAnswerButtonConstraints(){
        questionAnswerButton.snp.makeConstraints {
            $0.top.equalTo(questionBodyLabel.snp.bottom).offset(QuestionTableHeaderViewNameSpace.questionAnswerButtonTopOffset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.qusetionAnswerButtonLeadingInset)
            $0.trailing.equalTo(questionAnswerButton.snp.leading).offset(QuestionTableHeaderViewNameSpace.questionAnswerButtonWidth)
            $0.bottom.equalTo(questionAnswerButton.snp.top).offset(QuestionTableHeaderViewNameSpace.questionAnswerButtonHeight)
        }
    }
    
    private func makeBackgroundImageViewConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(questionHeaderLabel.snp.top).offset(QuestionTableHeaderViewNameSpace.backgroundImageViewTopOffset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.backgroundImageViewLeadingInset)
            $0.trailing.equalTo(todayQuestionView.snp.trailing)
            $0.bottom.equalTo(todayQuestionView.snp.bottom)
        }
    }
    
    private func makeSectionHeaderLabelConstraints() {
        sectionHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(todayQuestionView.snp.bottom).offset(QuestionTableHeaderViewNameSpace.sectionHeaderLabelTopOffset)
            $0.leading.equalToSuperview().inset(QuestionTableHeaderViewNameSpace.sectionHeaderLabelLeadingInset)
            $0.bottom.equalTo(sectionHeaderLabel.snp.top).offset(QuestionTableHeaderViewNameSpace.sectionHeaderLabelHeight)
        }
    }
}

// MARK: Data setUp method.
extension QuestionTableHeaderView {
    private func setUpData() {
        self.model
            .withUnretained(self)
            .bind { v, question in
                v.questionIndexLabel.rx.text.onNext(String(question.index))
                v.questionHeaderLabel.rx.text.onNext(question.header)
                v.questionBodyLabel.rx.text.onNext(question.body)
                
                if question.isMyAnswer {
                    v.questionAnswerButton.rx.title().onNext(QuestionTableHeaderViewNameSpace.questionAnswerButtonUpdateTitleText)
                    v.questionAnswerButton.setTitleColor(UIColor(named: QuestionTableHeaderViewNameSpace.questionAnswerButtonUpdateTitleTextColor), for: .normal)
                    v.questionAnswerButton.rx.backgroundColor.onNext(UIColor(named: QuestionTableHeaderViewNameSpace.questionAnswerButtonUpdateBackgroundColor))
                } else {
                    v.questionAnswerButton.rx.title().onNext(QuestionTableHeaderViewNameSpace.questionAnswerButtonBaseTitleText)
                    v.questionAnswerButton.setTitleColor(.white, for: .normal)
                    v.questionAnswerButton.rx.backgroundColor.onNext(.black)
                }
            }.disposed(by: disposeBag)
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
