//
//  MainNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/02.
//

import UIKit
import SnapKit

enum MainNavigationBarType {
    case question
    case challenge
    case myPage
}

final class MainNavigationBar: UIView {
    let type: MainNavigationBarType
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        
        switch type {
        case .question:
            label.text = MainNavigationBarNameSpace.titleLableQuestionTypeText
        case .challenge:
            label.text = MainNavigationBarNameSpace.titleLabelChallengeTypeText
        case .myPage:
            label.text = MainNavigationBarNameSpace.titleLabelMyPageTypeText
        }
        
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: MainNavigationBarNameSpace.titleLAbelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var chatRoomButton: CustomChatRoomButton = { CustomChatRoomButton() }()
    
    init(type: MainNavigationBarType) {
        self.type = type
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: MainNavigationBarNameSpace.height)))
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: MainNavigationBarNameSpace.shadowPathCornerRadius).cgPath
        layer.shadowColor = UIColor(red: MainNavigationBarNameSpace.shadowRedColor,
                                    green: MainNavigationBarNameSpace.shadowGreenColor,
                                    blue: MainNavigationBarNameSpace.shadowBlueColor,
                                    alpha: MainNavigationBarNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = MainNavigationBarNameSpace.shadowOpacity
        layer.shadowRadius = MainNavigationBarNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: MainNavigationBarNameSpace.shadwoOffsetWidth,
                                    height: MainNavigationBarNameSpace.shadowOffsetHeight)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstratins()
        makeChatRoomButtonConstraints()
    }
}

extension MainNavigationBar {
    private func addViewSubComponents() {
        [titleLable, chatRoomButton].forEach { addSubview($0) }
    }
    
    private func makeTitleLabelConstratins() {
        titleLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeChatRoomButtonConstraints() {
        chatRoomButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.width.equalTo(CustomChatRoomButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(CustomChatRoomButtonNameSpace.profileImageViewHeight)
        }
    }
}

extension MainNavigationBar {
    public func makeNavigationBarConstraints() {
        self.snp.makeConstraints {
            $0.top.equalTo(superview!.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.top).offset(MainNavigationBarNameSpace.height)
        }
    }
}
 
#if DEBUG

import SwiftUI

struct MainNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationBar_Presentable()
    }
    
    struct MainNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MainNavigationBar(type: .myPage)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
