//
//  ToastMessage.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ToastMessageType: String {
    case passwordSetting = "암호를 설정했어요."
    case requestAnswer = "연인이 아직 답변을 작성하지 않았어요."
}

final class ToastMessage: UIView {
    let type: ToastMessageType
    private let disposeBag = DisposeBag()
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: UIScreen.main.bounds.width - (ToastMessageNameSpace.contentViewLeadingInset + ToastMessageNameSpace.contentViewTrailingInset),
                                                     height: ToastMessageNameSpace.contentViewHeight)))
        view.backgroundColor = UIColor.black.withAlphaComponent(ToastMessageNameSpace.contentViewBackgroundColorAlpha)
        view.layer.cornerRadius = ToastMessageNameSpace.contentViewCornerRadius
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                             cornerRadius: ToastMessageNameSpace.contentViewCornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.withAlphaComponent(ToastMessageNameSpace.contentViewShadowColorAlpha).cgColor
        view.layer.shadowOpacity = ToastMessageNameSpace.contentViewShadowOpacity
        view.layer.shadowOffset = CGSize(width: ToastMessageNameSpace.contentViewShadowOffsetWidth,
                                         height: ToastMessageNameSpace.contentViewShadowOffsetHeight)
        view.layer.shadowRadius = ToastMessageNameSpace.contentViewShadowRadius
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = ToastMessageNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ToastMessageNameSpace.messageLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var requestAnswerButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero,
                                            size: CGSize(width: ToastMessageNameSpace.requestAnswerButtonWidth,
                                                         height: ToastMessageNameSpace.requestAnswerButtonHeight)))
        button.setTitle(ToastMessageNameSpace.requestAnswerButtonTitleText,
                        for: .normal)
        button.setTitleColor(UIColor(red: ToastMessageNameSpace.requestAnswerButtonTextColorRed,
                                     green: ToastMessageNameSpace.requestAnswerButtonTextColorGreen,
                                     blue: ToastMessageNameSpace.requestAnswerButtonTextColorBlue,
                                     alpha: ToastMessageNameSpace.requestAnswerButtonTextColorAlpha),
                             for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: ToastMessageNameSpace.requestAnswerButtonTitleLabelTextSize)
        button.layer.addBorder([.bottom],
                               color: UIColor(red: ToastMessageNameSpace.requestAnswerButtonTextColorRed,
                                              green: ToastMessageNameSpace.requestAnswerButtonTextColorGreen,
                                              blue: ToastMessageNameSpace.requestAnswerButtonTextColorBlue,
                                              alpha: ToastMessageNameSpace.requestAnswerButtonTextColorAlpha),
                               width: ToastMessageNameSpace.requestAnswerButtonBorderWidth)
        button.backgroundColor = .clear
        return button
    }()
    
    init(type: ToastMessageType) {
        self.type = type
        super.init(frame: .zero)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
        
        // TODO: 터치 이벤트 Rx로
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // TODO: 터치 이벤트 Rx로 
    @objc func handleTap(sender: UITapGestureRecognizer) {
        hide()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        requestAnswerButton.rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.hide()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeContentViewConstraints()
        makeContentStackViewConstraints()
    }
}

extension ToastMessage {
    private func addViewSubComponents() { addSubview(contentView) }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.equalToSuperview().inset(ToastMessageNameSpace.contentViewLeadingInset)
            $0.trailing.equalToSuperview().inset(ToastMessageNameSpace.contentViewTrailingInset)
            $0.height.equalTo(ToastMessageNameSpace.contentViewHeight)
        }
    }
    
    private func addContentViewSubComponents() { contentView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ToastMessageNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalToSuperview().inset(ToastMessageNameSpace.contentStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        switch type {
        case .requestAnswer:
            [messageLabel, requestAnswerButton].forEach { contentStackView.addArrangedSubview($0) }
        default:
            contentStackView.addArrangedSubview(messageLabel)
        }
    }
}

extension ToastMessage {
    public func show(completion: @escaping () -> Void = {}) {
        switch type {
        case .requestAnswer:
            contentView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(ToastMessageNameSpace.contentViewRequestAnswerTypeTopInset)
                $0.leading.equalToSuperview().inset(ToastMessageNameSpace.contentViewLeadingInset)
                $0.trailing.equalToSuperview().inset(ToastMessageNameSpace.contentViewTrailingInset)
                $0.height.equalTo(ToastMessageNameSpace.contentViewHeight)
            }
        default:
            break
        }
        
        UIView.animate(
            withDuration: CustomAlertViewNameSpace.popUpAnimatDuration,
            delay: CustomAlertViewNameSpace.animateDelay,
            options: .curveEaseInOut,
            animations: self.layoutIfNeeded,
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
        contentView.snp.remakeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.equalToSuperview().inset(ToastMessageNameSpace.contentViewLeadingInset)
            $0.trailing.equalToSuperview().inset(ToastMessageNameSpace.contentViewTrailingInset)
            $0.height.equalTo(ToastMessageNameSpace.contentViewHeight)
        }
        
        UIView.animate(
            withDuration: CustomAlertViewNameSpace.popUpAnimatDuration,
            delay: CustomAlertViewNameSpace.animateDelay,
            options: .curveEaseInOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )
        
        self.removeFromSuperview()
    }
}

#if DEBUG

import SwiftUI

struct ToastMessage_Previews: PreviewProvider {
    static var previews: some View {
        ToastMessage_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ToastMessage_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ToastMessage(type: .requestAnswer)
            v.show()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
