//
//  CustomChatRoomButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/02.
//

import UIKit
import SnapKit

final class CustomChatRoomButton: UIButton {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        imageView.image = UIImage(named: CustomChatRoomButtonNameSpace.profileImageViewImage)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = CustomChatRoomButtonNameSpace.profileImageViewBorderWidth
        imageView.layer.cornerRadius = CustomChatRoomButtonNameSpace.profileImageViewCornerRadius
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: CustomChatRoomButtonNameSpace.profileImageViewWidth,
                                              height: CustomChatRoomButtonNameSpace.profileImageViewHeight)))
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        backgroundColor = .clear
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: CustomChatRoomButtonNameSpace.profileImageViewCornerRadius).cgPath
        layer.shadowColor = UIColor(red: CustomChatRoomButtonNameSpace.shadowRedColor,
                                    green: CustomChatRoomButtonNameSpace.shadowGreenColor,
                                    blue: CustomChatRoomButtonNameSpace.shadowBlueColor,
                                    alpha: CustomChatRoomButtonNameSpace.shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: CustomChatRoomButtonNameSpace.shadowOffsetWidth,
                                    height: CustomChatRoomButtonNameSpace.shadowOffsetHeight)
        layer.shadowOpacity = CustomChatRoomButtonNameSpace.shadowOpacity
        layer.shadowRadius = CustomChatRoomButtonNameSpace.shadowRadius
    }
    
    private func addSubComponents() {
        addSubview(profileImageView)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(CustomChatRoomButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(CustomChatRoomButtonNameSpace.profileImageViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomChatRoomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomChatRoomButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: CustomChatRoomButtonNameSpace.profileImageViewWidth,
                   height: CustomChatRoomButtonNameSpace.profileImageViewHeight,
                   alignment: .center)
    }
    
    struct CustomChatRoomButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomChatRoomButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif



