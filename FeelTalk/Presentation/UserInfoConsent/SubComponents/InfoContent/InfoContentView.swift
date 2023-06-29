//
//  InfoContentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/08.
//

import UIKit
import SnapKit

enum ConsentInfoType {
    case sensitive
    case personal
}

final class InfoContentView: UIView {
    private var consentInfoType: ConsentInfoType
    
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 3.86
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var totalCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_total_check_unselected"), for: .normal)
        button.setImage(UIImage(named: "icon_total_check_selected"), for: .selected)
        button.setImage(UIImage(named: "icon_total_check_impossible"), for: .disabled)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch consentInfoType {
        case .sensitive:
            label.text = "민감정보 처리에 대한 동의"
        case .personal:
            label.text = "개인정보수집에 대한 동의"
        }
        
        label.font = UIFont(name: "pretendard-medium", size: 18.0)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: 정확히 어떤 기능인지 아직 불분명
    lazy var pushInfoDetailViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_right_arrow"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "gray_400")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(consentInfoType: ConsentInfoType) {
        self.consentInfoType = consentInfoType
        super.init(frame: .zero)
        
        self.setConfig()
    }
    
    // SubComponents
    private lazy var sensitiveInfoContentView = SensitiveInfoContentView()
    lazy var personalInfoContentView = PersonalInfoContentView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [totalCheckButton, titleLabel, pushInfoDetailViewButton].forEach { topHorizontalStackView.addArrangedSubview($0) }
        
        totalCheckButton.snp.makeConstraints { $0.width.equalTo((UIScreen.main.bounds.width / 100) * 4.93) }
        
        [topHorizontalStackView, separator].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        topHorizontalStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 8.25)
        }
        
        separator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 0.12)
        }
        
        switch consentInfoType {
        case .sensitive:
            totalVerticalStackView.addArrangedSubview(sensitiveInfoContentView)
            sensitiveInfoContentView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 11.82)
            }
        case .personal:
            totalVerticalStackView.addArrangedSubview(personalInfoContentView)
            
            personalInfoContentView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 11.82)
            }
        }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct InfoContentView_Previews: PreviewProvider {
    static var previews: some View {
        InfoContentView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct InfoContentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InfoContentView(consentInfoType: .sensitive)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
