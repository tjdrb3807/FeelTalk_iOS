//
//  ChatRoomButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit

enum ChatRoomButtonNameSpace {
    static let backgroundImage: String = "image_default_profile"
    static let backgroundColor: String = "main_500"
    static let borderWidth: CGFloat = 3.0
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 6.89  // 56
    static let cornerRadius: CGFloat = height / 2
    static let topInset: CGFloat = (UIScreen.main.bounds.height / 100) * 5.66 // 46
    static let leadingOffset: CGFloat = -height
    static let trailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33   // 20
}
