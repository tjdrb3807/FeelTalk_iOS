//
//  HomeNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/11.
//

import UIKit
import SnapKit

final class HomeNavigationBar: UIView {
    private lazy var messageBubbleLabel: UILabel = {
        let label = UILabel()
        
        
        return label
    }()
    
    lazy var chatRoomButton: CustomChatRoomButton = { CustomChatRoomButton() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubcomponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubcomponents() {
        addNavigationBarSubComponents()
    }
    
    private func setConstraints() {
        makeChatRoomButtonConstraints()
    }
}

extension HomeNavigationBar {
    private func addNavigationBarSubComponents() {
        [chatRoomButton].forEach { addSubview($0) }
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

#if DEBUG

import SwiftUI

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar_Presentable()
    }
    
    struct HomeNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeNavigationBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
