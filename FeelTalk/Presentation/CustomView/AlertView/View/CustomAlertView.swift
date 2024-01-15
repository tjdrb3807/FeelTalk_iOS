//
//  CustomAlertView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomAlertView: UIView {
    var type: CustomAlertType
    private let disposeBag = DisposeBag()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = CustomAlertViewNameSpace.contentViewCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = CustomAlertViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = CustomAlertViewNameSpace.labelStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch type {
        case .inquiry:
            label.text = CustomAlertViewNameSpace.titleLabelInquiryTypeText
        case .suggestion:
            label.text = CustomAlertViewNameSpace.titleLabelSuggestionTypeText
        case .breakUp:
            label.text = CustomAlertViewNameSpace.titleLableBreakUpTypeText
        case .challengeAddCancel:
            label.text = CustomAlertViewNameSpace.titleLabelChallengeAddCancelTypeText
        case .popAnswer:
            label.text = CustomAlertViewNameSpace.titleLabelPopAnswerTypeText
        case .sendAnswer:
            label.text = CustomAlertViewNameSpace.titleLabelSendAnswerTypeText
        case .deregisterChallenge:
            label.text = "챌린지 등록을 그만두시겠어요?"
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = CustomAlertViewNameSpace.titleLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: CustomAlertViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: CustomAlertViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        switch type {
        case .inquiry, .suggestion, .challengeAddCancel, .popAnswer, .deregisterChallenge:
            label.text = CustomAlertViewNameSpace.descriptionLabelDeleteGuideText
        case .breakUp:
            label.text = CustomAlertViewNameSpace.descriptionLabelBreakUpTypeText
        case .sendAnswer:
            label.text = CustomAlertViewNameSpace.descriptionLabelSendAnswerTypeText
        }
        
        label.textColor = .black
        label.numberOfLines = CustomAlertViewNameSpace.descriptionLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: CustomAlertViewNameSpace.descriptionLabelTextSize)
        
        label.backgroundColor = .clear
        label.setLineHeight(height: CustomAlertViewNameSpace.descriptionLabelLineHeight)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = CustomAlertViewNameSpace.buttonStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        
        switch type {
        case .inquiry, .suggestion, .challengeAddCancel, .deregisterChallenge:
            button.setTitle(CustomAlertViewNameSpace.leftButtonContinuingTitleText,
                            for: .normal)
        case .breakUp:
            button.setTitle(CustomAlertViewNameSpace.leftButtonBreakUpTypeTitleText,
                            for: .normal)
        case .popAnswer, .sendAnswer:
            button.setTitle("취소", for: .normal)
        }
        
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        button.layer.cornerRadius = CustomAlertViewNameSpace.buttonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        
        switch type {
        case .inquiry, .suggestion:
            button.setTitle(CustomAlertViewNameSpace.rightButtonGetoutTitleText,
                            for: .normal)
        case .breakUp:
            button.setTitle(CustomAlertViewNameSpace.rightButtonBreakUpTypeTitleText,
                            for: .normal)
        case .challengeAddCancel:
            button.setTitle(CustomAlertViewNameSpace.rightButtonChallengeAddCancelTypeText,
                            for: .normal)
        case .popAnswer:
            button.setTitle("나가기", for: .normal)
        case .sendAnswer:
            button.setTitle("보내기", for: .normal)
        case .deregisterChallenge:
            button.setTitle("삭제하기", for: .normal)
        }
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = CustomAlertViewNameSpace.buttonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    init(type: CustomAlertType) {
        self.type = type
        super.init(frame: .zero)
        
        self.bind()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        leftButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind { v, _ in
                v.hide()
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSucComponents()
        addLabelStackViewSubComponents()
        addButtonStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeContentViewConstraints()
        makeButtonStackViewConstraints()
    }
}

extension CustomAlertView {
    private func addViewSubComponents() {
        [contentView, contentStackView].forEach { addSubview($0) }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(-CustomAlertViewNameSpace.contentViewTopOffset)
        }
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.top).offset(CustomAlertViewNameSpace.contentViewTopOffset)
            $0.leading.equalTo(contentStackView.snp.leading).offset(CustomAlertViewNameSpace.contentViewLeadingOffset)
            $0.trailing.equalTo(contentStackView.snp.trailing).offset(CustomAlertViewNameSpace.contentViewtrailingOffset)
            $0.bottom.equalTo(contentStackView.snp.bottom).offset(CustomAlertViewNameSpace.contentViewBottomOffset)
        }
    }
    
    private func addContentStackViewSucComponents() {
        [labelStackView, buttonStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func makeButtonStackViewConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.width.equalTo(CustomAlertViewNameSpace.buttonStackViewWidth)
            $0.height.equalTo(CustomAlertViewNameSpace.buttonStackViewHeight)
        }
    }
    
    private func addButtonStackViewSubComponents() {
        [leftButton, rightButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
}

extension CustomAlertView {
    public func show(completion: @escaping () -> Void = {}) {
        contentStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(CustomAlertViewNameSpace.contentStackViewTopInset)
        }
        
        UIView.animate(
            withDuration: CustomAlertViewNameSpace.popUpAnimatDuration,
            delay: CustomAlertViewNameSpace.animateDelay,
            options: .curveEaseInOut,
            animations: { self.backgroundColor = UIColor.black.withAlphaComponent(CustomAlertViewNameSpace.backgroundColorAlpha) },
            completion: nil
        )
        
        UIView.animate(
            withDuration: CustomAlertViewNameSpace.dampingAnimateDuration,
            delay: CustomAlertViewNameSpace.animateDelay,
            usingSpringWithDamping: CustomAlertViewNameSpace.dampingAnimateSpring,
            initialSpringVelocity: CustomAlertViewNameSpace.dampingAnimateVelocity,
            options: [],
            animations: self.layoutIfNeeded,
            completion: { _ in completion() }
        )
    }
    
    public func hide(completion: @escaping () -> Void = {}) {
        contentStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(-CustomAlertViewNameSpace.contentViewTopOffset)
        }
        
        self.removeFromSuperview()
    }
}

#if DEBUG

import SwiftUI

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct CustomAlertView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = CustomAlertView(type: .deregisterChallenge)
            view.show()
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
