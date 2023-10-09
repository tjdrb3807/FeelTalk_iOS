//
//  ChatRoomButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit
import SnapKit

final class ChatRoomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: 56,
                                              height: 56)))
        
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        setBackgroundImage(UIImage(named: ChatRoomButtonNameSpace.backgroundImage),
                                for: .normal)
        backgroundColor = UIColor(named: ChatRoomButtonNameSpace.backgroundColor)
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = ChatRoomButtonNameSpace.borderWidth
        layer.cornerRadius = ChatRoomButtonNameSpace.cornerRadius
        
        
    }
}

#if DEBUG

import SwiftUI

struct ChatRoomButton_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomButton_Presentable()
    }
    
    struct ChatRoomButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatRoomButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
