//
//  LoginLogoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import UIKit
import SnapKit

final class LoginLogoView: UIStackView {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: LoginLogoViewNameSpace.logoImageViewImage)

        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LoginLogoViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.payboocMedium,
                            size: LoginLogoViewNameSpace.descriptionLabelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = LoginLogoViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeLogoImageViewConstraints()
    }
}

extension LoginLogoView {
    private func addViewSubComponents() {
        [logoImageView, descriptionLabel].forEach { addArrangedSubview($0) }
    }
    
    private func makeLogoImageViewConstraints() {
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(LoginLogoViewNameSpace.logoImageViewWidth)
            $0.height.equalTo(LoginLogoViewNameSpace.logoImageViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LoginLogoView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLogoView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: LoginLogoViewNameSpace.height,
                   alignment: .center)
    }
    
    struct LoginLogoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LoginLogoView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
