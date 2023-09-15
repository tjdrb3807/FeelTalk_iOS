//
//  ChatRoomBottomBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/11.
//

import UIKit
import SnapKit

final class ChatRoomBottomBar: UIStackView {
    private lazy var chatRoomBottomBarTopSpacing: UIView = { UIView() }()
    
    private lazy var contentHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        stackView.backgroundColor = .red
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var chatRoomBottomBarBottomSpacing: UIView = { UIView() }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 9
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 0.5
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0.0,
                                                     y: -1.0,
                                                     width: UIScreen.main.bounds.width,
                                                     height: 1.0)).cgPath
    }
    
    private func addSubComponents() {
        self.snp.makeConstraints { $0.height.equalTo(100)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        addChatRoomBottomBarSubComponents()
    }
    
    private func setConfigurations() {
        chatRoomBottomBarTopSpacing.snp.makeConstraints { $0.height.equalTo(0.0) }
        chatRoomBottomBarTopSpacing.backgroundColor = .green
        chatRoomBottomBarBottomSpacing.snp.makeConstraints { $0.height.equalTo(0.0) }
    }
}

extension ChatRoomBottomBar {
    private func addChatRoomBottomBarSubComponents() {
        [chatRoomBottomBarTopSpacing, contentHorizontalStackView, chatRoomBottomBarBottomSpacing].forEach { addArrangedSubview($0) }
        
        chatRoomBottomBarBottomSpacing.backgroundColor = .green
        
    }
    
    
}

#if DEBUG

import SwiftUI

struct ChatRoomBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomBottomBar_Presentable()
    }
    
    struct ChatRoomBottomBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatRoomBottomBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
