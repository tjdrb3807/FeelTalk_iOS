//
//  MainFlowNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit
import SnapKit

final class MainFlowNavigationBar: UIView {
    enum NavigationType {
        case home
        case question
    }
    
    private let navigationType: NavigationType
    
    // MARK: SubComponents
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch navigationType {
        case .home:
            break
        case .question:
            label.text = MainFlowNavigationBarNameSpace.titleLableQuestionTypeText
        }
        
        label.font = UIFont(name: MainFlowNavigationBarNameSpace.titleLabelTextFont,
                            size: MainFlowNavigationBarNameSpace.titleLabelTextSize)
        label.textColor = .black
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: MainFlowNavigationBarNameSpace.buttonContainerViewShadowOffsetWidth,
                                           height: MainFlowNavigationBarNameSpace.buttonContainerViewShadowOffestHeight)
        view.layer.shadowColor = UIColor(red: MainFlowNavigationBarNameSpace.buttonContainerViewShadowColorRed,
                                           green: MainFlowNavigationBarNameSpace.buttonContainerViewShadowColorGreen,
                                           blue: MainFlowNavigationBarNameSpace.buttonContainerViewShadowColorBlue,
                                           alpha: MainFlowNavigationBarNameSpace.buttonContainerViewShadowColorAlpha).cgColor
        view.layer.shadowOpacity = MainFlowNavigationBarNameSpace.buttonContainerViewShadowOpacity
        view.layer.shadowRadius = MainFlowNavigationBarNameSpace.buttonContainerViewShadowRadius
        view.clipsToBounds = false
        
        return view
    }()
    
    // TODO: 파트너 프로필 이미지로 변경
    private lazy var chatRoomButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: MainFlowNavigationBarNameSpace.chatRoomButtonBackgroundImage), for: .normal)
        button.backgroundColor = UIColor(named: MainFlowNavigationBarNameSpace.chatRoomButtonBackgroundColor)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = MainFlowNavigationBarNameSpace.chatRoomButtonBorderWidth
        button.layer.cornerRadius = MainFlowNavigationBarNameSpace.chatRoomButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    init(navigationType: NavigationType) {
        self.navigationType = navigationType
        super.init(frame: .zero)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        switch navigationType {
        case .home:
            break
        case .question:
            backgroundColor = UIColor(named: MainFlowNavigationBarNameSpace.navigationBarQuestionTypeBackgrountColor)
        }
        
        layer.shadowOffset = CGSize(width: MainFlowNavigationBarNameSpace.shadowOffsetWidth,
                                    height: MainFlowNavigationBarNameSpace.shadowOffsetHeight)
        layer.shadowColor = UIColor(red: MainFlowNavigationBarNameSpace.shadowColorRed,
                                    green: MainFlowNavigationBarNameSpace.shadowColorGreen,
                                    blue: MainFlowNavigationBarNameSpace.shadowColorBlue,
                                    alpha: MainFlowNavigationBarNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = MainFlowNavigationBarNameSpace.shadowOpacity
        layer.shadowRadius = MainFlowNavigationBarNameSpace.shadowRadius
        clipsToBounds = false
    }
    
    private func addSubComponents() {
        addButtonContainerViewSubComponents()
        [titleLabel, buttonContainerView].forEach { addSubview($0) }
    }
    
    private func setConfiguration() {
        makeTitleLabelConstraints()
        makeChatRoomButtonConstraints()
        makeButtonViewConstraints()
    }
}

// MARK: UI setting method
extension MainFlowNavigationBar {
    private func addButtonContainerViewSubComponents() {
        buttonContainerView.addSubview(chatRoomButton)
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(MainFlowNavigationBarNameSpace.titleLabelLeadingInset)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func makeChatRoomButtonConstraints() {
        chatRoomButton.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeButtonViewConstraints() {
        buttonContainerView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(MainFlowNavigationBarNameSpace.buttonContainerViewTrailingInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(MainFlowNavigationBarNameSpace.buttonbuttonContainerViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct MainFlowNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        MainFlowNavigationBar_Presentable()
    }
    
    struct MainFlowNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MainFlowNavigationBar(navigationType: .question)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
