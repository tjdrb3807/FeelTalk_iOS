//
//  AdultCertificationView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/13.
//

import UIKit
import SnapKit

final class AdultCertificationView: UIStackView {
    lazy var idCard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SignUpViewNameSpace.idCardImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var explanationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = SignUpViewNameSpace.explanationHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var explanationLabel: UILabel = {
        let label = UILabel()
        label.text = SignUpViewNameSpace.explanationLabelText
        label.setLineSpacing(spacing: SignUpViewNameSpace.explanationLabelLineSpacing)
        label.textColor = UIColor(named: SignUpViewNameSpace.explanationLabelTextColor)
        label.font = UIFont(name: SignUpViewNameSpace.explanationLabelTextFont, size: SignUpViewNameSpace.explanationLabelTextSize)
        label.numberOfLines = SignUpViewNameSpace.explanationLabelNumberOfLines
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SignUpViewNameSpace.checkImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    lazy var authButtton: UIButton = {
        let button = UIButton()
        button.setTitle(SignUpViewNameSpace.authButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: SignUpViewNameSpace.authButtonTitle, size: SignUpViewNameSpace.authButtonTitleSize)
        button.backgroundColor = UIColor(named: SignUpViewNameSpace.authButtonBackgroundColor)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = SignUpViewNameSpace.authButtonHeight / 2
        
        return button
    }()
    
    lazy var spacingView: UIView = { UIView() }()
    
    lazy var informationConsentView: InformationConsentView = { InformationConsentView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAttribute() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = SignUpViewNameSpace.adultCertificationViewSpacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        explanationHorizontalStackView.addArrangedSubview(explanationLabel)
        
        [idCard, explanationHorizontalStackView, authButtton].forEach { addArrangedSubview($0) }
    }
    
    private func setConfiguration() {
        idCard.snp.makeConstraints {
            $0.height.equalTo(SignUpViewNameSpace.idCardHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        authButtton.snp.makeConstraints {
            $0.height.equalTo(SignUpViewNameSpace.authButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(SignUpViewNameSpace.authButtonLeadingInset)
        }
    }
}

extension AdultCertificationView {
    func setAuthSuccessUI() {
        explanationHorizontalStackView.addArrangedSubview(checkImageView)
        removeArrangedSubview(authButtton)
        authButtton.removeFromSuperview()
        [spacingView, informationConsentView].forEach { addArrangedSubview($0) }
        
        spacingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpViewNameSpace.spacingViewHeight)
        }
        
        informationConsentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultCertificationView_Previews: PreviewProvider {
    static var previews: some View {
        AdultCertificationView_Presentable()
    }
    
    struct AdultCertificationView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultCertificationView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
