//
//  SignUpFlowNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import UIKit
import SnapKit

final class SignUpFlowNavigationBar: UIView {
    enum NavigationType {
        case signUp
        case nickname
        case inviteCode
    }
    
    private let navigationType: NavigationType
    
    // MARK: SubComponents.
    lazy var leftButton: UIButton = {
        let button = UIButton()
        
        switch navigationType {
        case .signUp:
            button.setImage(UIImage(named: SignUpFlowNavigationBarNameSpace.leftButtonSignUpTypeImage),
                            for: .normal)
        case .nickname:
            button.setImage(UIImage(named: SignUpFlowNavigationBarNameSpace.leftButtonSignUpTypeImage),
                            for: .normal)
        case .inviteCode:
            break
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch navigationType {
        case .signUp, .nickname:
            label.text = SignUpFlowNavigationBarNameSpace.titleLabelSignUpTypeText
        case .inviteCode:
            label.text = SignUpFlowNavigationBarNameSpace.titleLabelInviteCodeTypeText
        }
        
        label.textColor = .black
        label.font = UIFont(name: SignUpFlowNavigationBarNameSpace.titleLabelTextFont,
                            size: SignUpFlowNavigationBarNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    
    init(viewType: NavigationType) {
        self.navigationType = viewType
        super.init(frame: .zero)
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Default view setting method.
    private func setAttribute() {
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [leftButton, titleLabel].forEach { addSubview($0) }
    }
    
    private func setConfiguration() {
        makeLeftButtonConstraints()
        makeTitleLabelConstraints()
    }
}

// MARK: UI setting method.
extension SignUpFlowNavigationBar {
    private func makeLeftButtonConstraints() {
        leftButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(SignUpFlowNavigationBarNameSpace.leftButtonWidth)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct SignUpFlowNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        SignUpFlowNavigationBar_Presentalbe()
    }
    
    struct SignUpFlowNavigationBar_Presentalbe: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignUpFlowNavigationBar(viewType: .signUp)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
