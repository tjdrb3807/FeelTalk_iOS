//
//  PartnerAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PartnerAnswerView: UIStackView {
    let model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()

    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .partnerAnswer, isRequiredInput: false) }()
    
    private lazy var answerTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                               size: PartnerAnswerViewNameSpace.answerTextViewTextSize)
        textView.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        textView.layer.cornerRadius = PartnerAnswerViewNameSpace.answerTextViewCornerRadius
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: PartnerAnswerViewNameSpace.answerTextViewContainerTopInset,
                                                   left: PartnerAnswerViewNameSpace.answerTextViewContainerLeftInset,
                                                   bottom: PartnerAnswerViewNameSpace.answerTextViewContainerBottomInset,
                                                   right: PartnerAnswerViewNameSpace.answerTextViewContainerRightInset)
        textView.isEditable = false
        
        return textView
    }()
    
    lazy var noAnswerView: PartnerNoAnswerView = { PartnerNoAnswerView() }()
    
    lazy var gotAnswerView: PartnerGotAnswerView = { PartnerGotAnswerView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind () {
        model
            .withUnretained(self)
            .bind { v, model in
                v.setData(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = PartnerAnswerViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        [inputViewTitle].forEach { self.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        makeInputViewTitleConstraints()
    }
}

extension PartnerAnswerView {
    private func makeInputViewTitleConstraints() {
        inputViewTitle.snp.makeConstraints { $0.height.equalTo(PartnerAnswerViewNameSpace.inputViewTitleHeight)}
    }
}

extension PartnerAnswerView {
    func setData(with model: Question) {
        if model.isMyAnswer && model.isPartnerAnswer {  // 둘 다 답변한 경우
            answerTextView.rx.text.onNext(model.partnerAnser)
            addArrangedSubview(answerTextView)
            answerTextView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(PartnerAnswerViewNameSpace.answerTextViewHeight)
            }
        } else if model.isMyAnswer && !model.isPartnerAnswer {  // 나만 답변한 경우
            addArrangedSubview(noAnswerView)
            noAnswerView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(PartnerNoAnswerViewNameSpace.height)
            }
        } else if !model.isMyAnswer && model.isPartnerAnswer {  // 상대만 답변한 경우
            addArrangedSubview(gotAnswerView)
            gotAnswerView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(PartnerGotAnswerViewNameSpace.height)
            }
        } else {  // 둘 다 답변하지 않은 경우
            addArrangedSubview(noAnswerView)
            noAnswerView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(PartnerNoAnswerViewNameSpace.height)
            }
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerAnswerView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: CommonConstraintNameSpace.verticalRatioCalculator * 22.29,// 181.0
                   alignment: .center)
    }
    
    struct PartnerAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = PartnerAnswerView()
            v.model.accept(.init(index: 0,
                                  pageNo: 0,
                                  title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
                                  header: "난 이게 가장 좋더라!",
                                  body: "당신이 가장 좋아하는 스킨십은?",
                                  highlight: [0],
                                  myAnser: "이력서를 작성할 때 글자수를 확인하기 위해 포털사이트에 내용을 복사 붙여 넣기를 하여 확인하곤 합니다. 또한 공모전에 응모한다면 200자 원고지 100매와 같은 기준에 맞추기 위",
                                  partnerAnser: "bey",
                                  isMyAnswer: true,
                                  isPartnerAnswer: false,
                                  createAt: "hhh"))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
