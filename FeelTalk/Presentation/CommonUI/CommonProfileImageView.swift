//
//  CommonProfileImageView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit

enum SuperViewTypeOfProfileImage {
    case home
    case question
    case challenge
    case chat
}

final class CommonProfileImageView: UIImageView {
    private var superViewType: SuperViewTypeOfProfileImage
    
    init(superViewType: SuperViewTypeOfProfileImage) {
        self.superViewType = superViewType
        super.init(frame: .zero)
        
        self.setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "gray_400")
        layer.borderWidth = 2.0
        
        switch superViewType {
        case .home:
            layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 4.92) / 2
            layer.borderColor = UIColor.white.cgColor
        case .question:
            layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.94) / 2
            layer.borderColor = UIColor.white.cgColor
        case .challenge:
            layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 5.91) / 2
            layer.borderColor = UIColor(named: "gray_300")?.cgColor
        case .chat:
            layer.cornerRadius = ((UIScreen.main.bounds.width / 100) * 7.46) / 2
            layer.borderColor = UIColor(named: "gray_300")?.cgColor
        }
    }
}


#if DEBUG

import SwiftUI

struct CommonProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CommonProfileImageView_Presentable()
    }
    
    struct CommonProfileImageView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CommonProfileImageView(superViewType: .home)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
