//
//  HomeTodayQuestionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeTodayQuestionView: UIView {
    let todayQuestion = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var descriptionView: HomeTodayQuestionDescriptionView = { HomeTodayQuestionDescriptionView() }()
    
    lazy var countView: HomeTodayQuestionCountView = { HomeTodayQuestionCountView() }()
    
    lazy var answerButton: HomeTodayQuesitonAnswerButton = { HomeTodayQuesitonAnswerButton() }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: HomeTodayQuestionViewNameSpace.imageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                                              height: HomeTodayQuestionViewNameSpace.height)))
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        todayQuestion
            .withUnretained(self)
            .bind { v, model in
                v.countView.count.accept(model.index)
                v.answerButton.todayQuestion.accept(model)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        layer.cornerRadius = HomeTodayQuestionViewNameSpace.cornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: HomeTodayQuestionViewNameSpace.cornerRadius).cgPath
        layer.shadowColor = UIColor(red: HomeTodayQuestionViewNameSpace.shadowRedColor,
                                    green: HomeTodayQuestionViewNameSpace.shadowGreenColor,
                                    blue: HomeTodayQuestionViewNameSpace.shadowBlueColor,
                                    alpha: HomeTodayQuestionViewNameSpace.shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: HomeTodayQuestionViewNameSpace.shadowOffsetWidth,
                                    height: HomeTodayQuestionViewNameSpace.height)
        layer.shadowOpacity = HomeTodayQuestionViewNameSpace.shadowOpacity
        layer.shadowRadius = HomeTodayQuestionViewNameSpace.shadowRadius
        clipsToBounds = true
        
    }
    
    private func addSubComponents() {
        [imageView, descriptionView, countView, answerButton].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        makeImageViewConstraints()
        makeDescriptionViewConstratins()
        makeCountViewConstraints()
        makeAnswerButtonConstraints()
    }
}

extension HomeTodayQuestionView {
    private func makeImageViewConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodayQuestionViewNameSpace.imageViewTopInset)
            $0.leading.equalToSuperview().inset(HomeTodayQuestionViewNameSpace.iamgeViewLeadingInset)
        }
    }
    
    private func makeDescriptionViewConstratins() {
        descriptionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodayQuestionDescriptionViewNameSpace.topInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.width.equalTo(HomeTodayQuestionDescriptionViewNameSpace.width)
            $0.height.equalTo(HomeTodayQuestionDescriptionViewNameSpace.height)
        }
    }
    
    private func makeCountViewConstraints() {
        countView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodayQuestionCountViewNameSpace.topInset)
            $0.left.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeAnswerButtonConstraints() {
        answerButton.snp.makeConstraints {
            $0.top.equalTo(countView.snp.bottom).offset(HomeTodayQuestionAnswerButtonNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.width.equalTo(HomeTodayQuestionAnswerButtonNameSpace.width)
            $0.height.equalTo(HomeTodayQuestionAnswerButtonNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeTodayQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodayQuestionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: HomeTodayQuestionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodayQuestionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeTodayQuestionView()
            v.todayQuestion.accept(.init(index: 100,
                                         pageNo: 1,
                                         title: "",
                                         header: "",
                                         body: "",
                                         highlight: [0, 1, 2],
                                         isMyAnswer: false,
                                         isPartnerAnswer: false,
                                         createAt: "2023-02-03"))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
