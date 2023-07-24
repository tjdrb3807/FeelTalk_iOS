//
//  CustomNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import UIKit
import SnapKit

enum NavigationType {
    case signUp
    case inviteCode
}

final class CustomNavigationBar: UIView {
    private let navigationType: NavigationType
    
    // MARK: SubComponents.
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        
        switch navigationType {
        case .signUp:
            button.setImage(UIImage(named: CustomNavigationBarNameSpace.leftButtonSignUpTypeImage),
                            for: .normal)
        case .inviteCode:
            button.setImage(UIImage(named: CustomNavigationBarNameSpace.leftButtonInviteCodeTypeImage),
                            for: .normal)
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch navigationType {
        case .signUp:
            label.text = CustomNavigationBarNameSpace.titleLabelSignUpTypeText
        case .inviteCode:
            label.text = CustomNavigationBarNameSpace.titleLabelInviteCodeTypeText
        }
        
        label.textColor = .black
        label.font = UIFont(name: CustomNavigationBarNameSpace.titleLabelTextFont,
                            size: CustomNavigationBarNameSpace.titleLabelTextSize)
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
extension CustomNavigationBar {
    private func makeLeftButtonConstraints() {
        leftButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(CustomNavigationBarNameSpace.leftButtonWidth)
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

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar_Presentalbe()
    }
    
    struct CustomNavigationBar_Presentalbe: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomNavigationBar(viewType: .signUp)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
