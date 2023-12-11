//
//  InfoConsentItemView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/30.
//

import UIKit
import SnapKit

enum InfoConsentItem: String {
    /// (회원가입) 성인 인증
    case adultAuth = "만 19세 이상입니다."
    /// (회원가입) 서비스 이용
    case serviceConsent = "서비스 이용 약관 동의"
    /// (회원가입) 개인정보
    case personalInfoConsent = "개인정보 수집 및 서비스 활용 동의"
    /// (회원가입) 민감정보
    case sensitiveInfoConsent = "민감정보 수집 및 서비스 활용 동의"
    /// (회원가입) 마케팅 정보
    case marketingInfoConsent = "마케팅 정보 수신 동의(푸시 알림)"
    /// (성인인증) 개인정보
    case AdultPersonalInfoConsent = "개인정보이용동의"
    /// (성인인증) 고유식별
    case AdultUniqueIdentificationInfoConsent = "고유식별정보처리동의"
    /// (성인인증) 서비스 이용
    case AdultServiceConsent = "서비스이용약관동의"
    /// (성인인증) 통신사이용
    case AdutlNewsAgencyUseConsent = "통신사시용약관동의"
}

enum InfoConsentOption {
    case none
    case essential
    case choice
}

final class InfoConsentItemView: UIStackView {
    private let type: InfoConsentItem
    private let option: InfoConsentOption
    
    private lazy var spacingView: UIView = { UIView() }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        
        switch type {
        case .adultAuth:
            button.setImage(UIImage(named: "icon_check_selected"), for: .normal)
            button.isEnabled = false
        default:
            button.setImage(UIImage(named: "icon_check_unselected"), for: .normal)
            button.setImage(UIImage(named: "icon_check_selected"), for: .selected)
            button.isEnabled = true
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        
        return stackView
    }()
    
    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        
        switch option {
        case .none:
            return label
        case .essential:
            label.text = "[필수]"
            label.textColor = UIColor(named: CommonColorNameSpace.main500)
        case .choice:
            label.text = "[선택]"
            label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        }
        
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        
        switch type {
        case .adultAuth:
            label.backgroundColor = .black
        default:
            label.backgroundColor = UIColor(named: CommonColorNameSpace.gray600)
        }
        
        label.text = type.rawValue
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.backgroundColor = .clear
        
        return label
    }()
    
    init(type: InfoConsentItem, option: InfoConsentOption) {
        self.type = type
        self.option = option
        
        super.init(frame: .zero)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = 8.0
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeSpacingViewConstraints()
    }
}

extension InfoConsentItemView {
    private func addViewSubComponents() {
        [spacingView, checkButton, contentStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeSpacingViewConstraints() {
        spacingView.snp.makeConstraints { $0.width.equalTo(4.0) }
    }
    
    private func addContentStackViewSubComponents() {
        [optionLabel, contentLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}


#if DEBUG

import SwiftUI

struct InfoConsentItemView_Previews: PreviewProvider {
    static var previews: some View {
        InfoConsentItemView_Presentable()
    }
    
    struct InfoConsentItemView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InfoConsentItemView(type: .AdultPersonalInfoConsent, option: .essential)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
