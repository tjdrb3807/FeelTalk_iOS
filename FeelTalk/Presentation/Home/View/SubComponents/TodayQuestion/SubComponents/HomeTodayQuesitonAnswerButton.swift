//
//  HomeTodayQuesitonAnswerButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeTodayQuesitonAnswerButton: UIButton {
    let todayQuestion = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = HomeTodayQuestionAnswerButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: HomeTodayQuestionAnswerButtonNameSpace.contentLableTextSize)
        label.setLineHeight(height: HomeTodayQuestionAnswerButtonNameSpace.contentLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        todayQuestion
            .withUnretained(self)
            .bind { v, model in
                v.setProperties(with: model)
                v.setContentLabelProperties(with: model)
                v.setRightArrowImageViewProperties(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        layer.borderWidth = HomeTodayQuestionAnswerButtonNameSpace.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = HomeTodayQuestionAnswerButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addButtonSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeContentStackViewConstraints()
    }
}

extension HomeTodayQuesitonAnswerButton {
    private func addButtonSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [contentLabel, rightArrowImageView].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension HomeTodayQuesitonAnswerButton {
    private func setProperties(with model: Question) {
        if model.isMyAnswer {
            self.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main100)?.cgColor)
            self.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
        } else {
            self.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
            self.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main100))
        }
    }
    
    private func setContentLabelProperties(with model: Question) {
        if model.isMyAnswer {
            contentLabel.rx.text.onNext(HomeTodayQuestionAnswerButtonNameSpace.contentLabelCompletionAnswerTypeText)
            contentLabel.rx.textColor.onNext(.white)
        } else {
            contentLabel.rx.text.onNext(HomeTodayQuestionAnswerButtonNameSpace.contentLabelNoAnswerTypeText)
            contentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500))
        }
        
        contentLabel.snp.makeConstraints { $0.width.equalTo(contentLabel.intrinsicContentSize) }
    }
    
    private func setRightArrowImageViewProperties(with model: Question) {
        if model.isMyAnswer {
            rightArrowImageView.rx.image.onNext(UIImage(named: HomeTodayQuestionAnswerButtonNameSpace.rightImageViewCompletionAnswerTypeImage))
        } else {
            rightArrowImageView.rx.image.onNext(UIImage(named: HomeTodayQuestionAnswerButtonNameSpace.rightImageViewNoAnswerTypeImage) )
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeTodayQuesitonAnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodayQuesitonAnswerButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: HomeTodayQuestionAnswerButtonNameSpace.width,
                   height: HomeTodayQuestionAnswerButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodayQuesitonAnswerButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeTodayQuesitonAnswerButton()
            v.todayQuestion.accept(.init(index: 0,
                                         pageNo: 0,
                                         title: "",
                                         header: "",
                                         body: "",
                                         highlight: [0],
                                         isMyAnswer: true,
                                         isPartnerAnswer: false,
                                         createAt: ""))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
