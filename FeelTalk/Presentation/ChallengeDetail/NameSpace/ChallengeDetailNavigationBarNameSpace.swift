//
//  ChallengeDetailNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit

enum ChallengeDetailNavigationBarNameSpace {
    // MARK: ChallengeDetailNavigationBarNameSpace
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38                 // 60.0
    
    // MARK: Button
    static let buttonTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.73         // 6.0
    static let buttonBottomInset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.73      // 6.0
    static let buttomWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8             // 48.0
    
    // MARK: PopButton
    static let popButtonImage: String = "icon_x_mark_black"
    
    // MARK: ModifiyButton
    static let modifiyButtonImage: String = "icon_challenge_modifiy"
    
    // MARK: RemoveButton
    static let removeButtonImage: String = "icon_challenge_remove"
    
}
