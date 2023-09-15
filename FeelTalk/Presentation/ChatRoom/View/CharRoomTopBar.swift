//
//  CharRoomTopBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/11.
//

import UIKit
import SnapKit

final class ChatRoomTopBar: UIView {
    private lazy var partnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "pretendard-medium", size: 18.0)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var chatMenuButton: UIButton = {
        let button = UIButton()
        button.setImage((UIImage(named: "icon_chat_top_menu")),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        
    }
    
    private func addSubComponents() {
        [partnerNameLabel, chatMenuButton].forEach { addSubview($0) }
    }
    
    private func setConfigurations() {
        makePartnerNameLabelConstraints()
        makeChatMenuButtonConstraints()
    }
}

extension ChatRoomTopBar {
    private func makePartnerNameLabelConstraints() {
        partnerNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.equalTo(partnerNameLabel.intrinsicContentSize)
        }
    }
    
    private func makeChatMenuButtonConstraints() {
        chatMenuButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().inset(6.0)
            $0.leading.equalTo(chatMenuButton.snp.trailing).offset(-48)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(chatMenuButton.snp.top).offset(-48)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatRoomTopBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomTopBar_Presentable()
    }
    
    struct ChatRoomTopBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatRoomTopBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
