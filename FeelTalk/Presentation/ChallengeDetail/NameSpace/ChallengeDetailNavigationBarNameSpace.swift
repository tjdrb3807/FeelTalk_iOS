//
//  ChallengeDetailNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit

enum ChallengeDetailNavigationBarNameSpace {
    // MARK: ChallengeDetailNavigationBar
    /// 60.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    
    // MARK: Button
    /// 48.0
    static let buttonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 48.0
    static let buttonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    
    // MARK: ModifiyButton
    /// 48.0
    static let modifiyButtonTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
                
    
    // MARK: PopButton
    static let popButtonImage: String = "icon_x_mark_black"
    
    // MARK: ModifiyButton
    static let modifiyButtonImage: String = "icon_challenge_modifiy"
    
    // MARK: RemoveButton
    static let removeButtonImage: String = "icon_challenge_remove"
    
}
