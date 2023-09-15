//
//  AlertView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum AlertType {
    case cancelAnswer
    case sendAnswer
}

final class AlertView: UIView {
    let model = PublishRelay<AlertType>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = AlertViewNameSpace.contentViewCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = AlertViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = AlertViewNameSpace.labelStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()

    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AlertViewNameSpace.titleLabelCancelAnswerTypeText
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = AlertViewNameSpace.titleLabelNumberOfLines
        label.font = UIFont(name: AlertViewNameSpace.titleLabelTextFont,
                            size: AlertViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var subscriptLabel: UILabel = {
        let label = UILabel()
        label.text = AlertViewNameSpace.subscriptLabelCancelAnswerTypeText
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = AlertViewNameSpace.subscriptLabelNumberOfLines
        label.font = UIFont(name: AlertViewNameSpace.subscriptLabelTextFont,
                            size: AlertViewNameSpace.subscriptLabelTextSize)
        label.backgroundColor = .clear
        
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = AlertViewNameSpace.subscriptLabelLineSpacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = AlertViewNameSpace.buttonStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(AlertViewNameSpace.leftButtonCancelAnswerTypeTitleText,
                        for: .normal)
        button.setTitleColor(.black,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: AlertViewNameSpace.buttonTitleTextFont,
                                         size: AlertViewNameSpace.buttonTitleTextSize)
        button.backgroundColor = .white
        button.layer.borderWidth = AlertViewNameSpace.leftButtonBorderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = AlertViewNameSpace.buttonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(AlertViewNameSpace.rightButtonCancelAnswerTypeTitleText,
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: AlertViewNameSpace.buttonTitleTextFont,
                                         size: AlertViewNameSpace.buttonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = AlertViewNameSpace.buttonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor.black.withAlphaComponent(AlertViewNameSpace.backgroundAlpha)
        setData()
    }
    
    private func addSubComponents() {
        addAlertViewSubComponents()
        addContentViewSubComponents()
        addContentStackViewSubComponents()
        addLabelStackViewSubComponents()
        addButtonStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeContentViewConstratints()
        makeContentStackViewConstraints()
        makeButtonStakcViewConstraints()
        makeTitleLabelConstraints()
        makeSubscriptLabelConstraints()
        makeLeftButtonConstraints()
        makeRightButtonConstraints()
    }
}

extension AlertView {
    private func addAlertViewSubComponents() {
        addSubview(contentView)
    }
    
    private func makeContentViewConstratints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.top).offset(AlertViewNameSpace.contentViewTopOffSet)
            $0.leading.equalTo(contentStackView.snp.leading).offset(AlertViewNameSpace.contentViewLeadingOffset)
            $0.trailing.equalTo(contentStackView.snp.trailing).offset(AlertViewNameSpace.contentViewTrailingOffset)
            $0.bottom.equalTo(contentStackView.snp.bottom).offset(AlertViewNameSpace.contentViewBottomOffset)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(AlertViewNameSpace.contentViewCenterYInset)
        }
    }
    
    private func addContentViewSubComponents() {
        contentView.addSubview(contentStackView)
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(AlertViewNameSpace.contentStackViewWidth)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [labelStackView, buttonStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeButtonStakcViewConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, subscriptLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.height.equalTo(AlertViewNameSpace.titleLabelHeight) }
    }
    
    private func makeSubscriptLabelConstraints() {
        subscriptLabel.snp.makeConstraints {
            $0.height.equalTo(subscriptLabel.intrinsicContentSize).priority(AlertViewNameSpace.subscriptLabelPriority)
        }
    }
    
    private func addButtonStackViewSubComponents() {
        [leftButton, rightButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func makeLeftButtonConstraints() {
        leftButton.snp.makeConstraints { $0.height.equalTo(AlertViewNameSpace.buttonHeight) }
    }
    
    private func makeRightButtonConstraints() {
        rightButton.snp.makeConstraints { $0.height.equalTo(AlertViewNameSpace.buttonHeight) }
    }
}

extension AlertView {
    private func setData() {
        self.model
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, type in
                switch type {
                case .cancelAnswer:
                    v.titleLabel.rx.text.onNext(AlertViewNameSpace.titleLabelCancelAnswerTypeText)
                    v.subscriptLabel.rx.text.onNext(AlertViewNameSpace.subscriptLabelCancelAnswerTypeText)
                    v.leftButton.rx.title().onNext(AlertViewNameSpace.leftButtonCancelAnswerTypeTitleText)
                    v.rightButton.rx.title().onNext(AlertViewNameSpace.rightButtonCancelAnswerTypeTitleText)
                case .sendAnswer:
                    v.titleLabel.rx.text.onNext(AlertViewNameSpace.titleLabelSendAnswerTypeText)
                    v.subscriptLabel.rx.text.onNext(AlertViewNameSpace.subscriptLabelSnedAnswerTypeText)
                    v.leftButton.rx.title().onNext(AlertViewNameSpace.leftButtonSendAnswerTypeTitleText)
                    v.rightButton.rx.title().onNext(AlertViewNameSpace.rightButtonSendAnswerTypeTitleText)
                }
                
                v.layoutIfNeeded()
            }.disposed(by: disposeBag)
    }
}


#if DEBUG

import SwiftUI

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct AlertView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AlertView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
