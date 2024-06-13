//
//  MainNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/07.
//

import UIKit
import SnapKit

final class MainNavigationBar: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.payboocBold,
                            size: MainNavigationBarNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var logoImageView: UIImageView = { UIImageView() }()
    
    lazy var chatRoomButton: CustomChatRoomButton = { CustomChatRoomButton() }()
    
    init(type: MainNavigationBarType) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: MainNavigationBarNameSpace.height)))
        
        self.setProperites(with: type)
        self.addSubComponents(with: type)
        self.setConstratins(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperites(with type: MainNavigationBarType) {
        switch type {
        case .home:
            logoImageView.image = UIImage(named: type.rawValue)
            backgroundColor = .white
        case .question, .challenge, .myPage:
            titleLabel.text = type.rawValue
            backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        }
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: MainNavigationBarNameSpace.shadowPathCornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(MainNavigationBarNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = MainNavigationBarNameSpace.shadowOpacity
        layer.shadowRadius = MainNavigationBarNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: MainNavigationBarNameSpace.shadowOffsetWidth,
                                    height: MainNavigationBarNameSpace.shadowOffsetHeight)
    }
    
    private func addSubComponents(with type: MainNavigationBarType) {
        switch type {
        case .home:
            addSubview(logoImageView)
        case .question, .challenge, .myPage:
            addSubview(titleLabel)
        }
        
//        addSubview(chatRoomButton)
    }
    
    private func setConstratins(with type: MainNavigationBarType) {
        switch type {
        case .home:
            makeLogoImageViewConstraints()
        case .question, .challenge, .myPage:
            makeTitleLabelConstraints()
        }
        
//        makeChatRoomButtonConstraints()
    }
}

extension MainNavigationBar {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeLogoImageViewConstraints() {
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.width.equalTo(MainNavigationBarNameSpace.logoImageViewWidth)
            $0.height.equalTo(MainNavigationBarNameSpace.logoImageViewHeight)
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
    public func makeMainNavigationBarConstraints() {
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
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: MainNavigationBarNameSpace.height,
                   alignment: .center)
    }
    
    struct MainNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MainNavigationBar(type: .question)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
