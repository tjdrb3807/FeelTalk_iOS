//
//  CommonProfileImageView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

enum SuperViewTypeOfProfileImage {
    case home
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
        backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        
        switch superViewType {
        case .home:
            layer.cornerRadius = ((UIScreen.main.bounds.width / 100) * 10.66) / 2
        }
        
        translatesAutoresizingMaskIntoConstraints = false
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
