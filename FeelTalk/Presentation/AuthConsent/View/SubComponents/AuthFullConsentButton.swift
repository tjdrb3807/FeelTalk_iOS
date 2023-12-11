//
//  AuthFullConsentButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AuthFullConsentButton: UIButton {
    let isConsented = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = AuthFullConsentButtonNameSpace.contentStackViewSpacing
        stackView.isUserInteractionEnabled = false
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var checkIcon: UIImageView = { UIImageView() }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = AuthFullConsentButtonNameSpace.contentLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: AuthFullConsentButtonNameSpace.contentLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isConsented
            .withUnretained(self)
            .bind { v, state in
                v.updateCheckIconImage(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.borderWidth = AuthFullConsentButtonNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray300)?.cgColor
        layer.cornerRadius = AuthFullConsentButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstrints()
        makeCheckIconConstraints()
    }
}

extension AuthFullConsentButton {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstrints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AuthFullConsentButtonNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(AuthFullConsentButtonNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(AuthFullConsentButtonNameSpace.contentStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(AuthFullConsentButtonNameSpace.contentStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [checkIcon, contentLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeCheckIconConstraints() {
        checkIcon.snp.makeConstraints {
            $0.width.equalTo(checkIcon.snp.height)
        }
    }
}

extension AuthFullConsentButton {
    private func updateCheckIconImage(with state: Bool) {
        state ?
        checkIcon.rx.image.onNext(UIImage(named: AuthFullConsentButtonNameSpace.checkIconSelectedImage)) :
        checkIcon.rx.image.onNext(UIImage(named: AuthFullConsentButtonNameSpace.checkIconUnSelectedImage))
    }
}

#if DEBUG

import SwiftUI

struct AuthFullConsentButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthFullConsentButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AuthFullConsentButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct AuthFullConsentButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AuthFullConsentButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
