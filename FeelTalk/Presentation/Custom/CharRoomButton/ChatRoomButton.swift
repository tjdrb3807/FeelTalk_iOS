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
        super.init(frame: frame)
        
        self.setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.setBackgroundImage(UIImage(named: ChatRoomButtonNameSpace.backgroundImage),
                                for: .normal)
        self.backgroundColor = UIColor(named: ChatRoomButtonNameSpace.backgroundColor)
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = ChatRoomButtonNameSpace.borderWidth
        self.layer.cornerRadius = ChatRoomButtonNameSpace.cornerRadius
        self.clipsToBounds = true
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
