//
//  AppleButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import UIKit
import SnapKit

final class LoginButton: UIButton {
    /// snsType에 따라 icon, label 속성 설정
    /// - appleIOS
    /// - google
    /// - kakao
    /// - naver
    var snsType: SNSType
    
    // MARK: LoginButton sub components.
    private lazy var fullHorizontalStakcView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = LoginButtonNameSpace.fullHorizontalStakcViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        switch snsType {
        case .apple:
            imageView.image = UIImage(named: LoginButtonNameSpace.appleIcon)
        case .google:
            imageView.image = UIImage(named: LoginButtonNameSpace.googleIcon)
        case .kakao:
            imageView.image = UIImage(named: LoginButtonNameSpace.kakaoIcon)
        case .naver:
            imageView.image = UIImage(named: LoginButtonNameSpace.naverIcon)
        }
        
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: LoginButtonNameSpace.labelFont, size: LoginButtonNameSpace.labelSize)
        label.backgroundColor = .clear
        
        switch snsType {
        case .apple:
            label.text = LoginButtonNameSpace.appleText
        case .google:
            label.text = LoginButtonNameSpace.googleText
        case .kakao:
            label.text = LoginButtonNameSpace.kakaoText
        case .naver:
            label.text = LoginButtonNameSpace.naverText
        }
        
        return label
    }()
    
    // MARK: Initialization.
    init(snsType: SNSType) {
        self.snsType = snsType
        super.init(frame: .zero)
        
        self.setAttribution()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Default ui settings method.
    private func setAttribution() {
        backgroundColor = .white
        layer.borderColor = UIColor(named: LoginButtonNameSpace.borderColor)?.cgColor
        layer.borderWidth = LoginButtonNameSpace.borderWidth
        layer.cornerRadius = LoginButtonNameSpace.buttonHeight / 2
    }
    
    private func addSubComponents() {
        addFullStackViewSubViews()
        addSubview(fullHorizontalStakcView)
    }
    
    private func setConfiguration() {
        makeIconConstraints()
        makeLabelConstraints()
        makeFullHorizontalStackViewConstraints()
    }
}

//MARK: UI settings method.
extension LoginButton {
    private func addFullStackViewSubViews() {
        [icon, label].forEach { fullHorizontalStakcView.addArrangedSubview($0) }
    }
    
    private func makeIconConstraints() {
        icon.snp.makeConstraints {
            $0.width.equalTo(LoginButtonNameSpace.iconWidth)
            $0.height.equalTo(icon.snp.width)
        }
    }
    
    private func makeLabelConstraints() {
        label.snp.makeConstraints {
            $0.width.equalTo(label.intrinsicContentSize)
            $0.height.equalTo(icon.snp.height)
        }
    }
    
    private func makeFullHorizontalStackViewConstraints() {
        fullHorizontalStakcView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton_Presentable()
    }
    
    struct LoginButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LoginButton(snsType: .kakao)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
