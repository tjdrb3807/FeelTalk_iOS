//
//  ChatViewConstraintsNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/02.
//

import Foundation
import UIKit

enum ChatViewConstraintValueNameSpace {
    // MARK: TopBar constraint value.
    static let partnerNameLabelFontSize: CGFloat = 18.0
    static let topBarHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38
    static let topBarLeftSpacerWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    static let topBarRightSpacerWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    static let topBarVerticalSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.73
    
    // MARK: BottomBar constraint value.
    static let bottomBarBottomSpaceHeight: CGFloat = 0.0
    
    static let bottomBarContentHorizontalStackViewLeftSpaceWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 1.6
    static let bottomBarContentHorizontalStackViewMiddleSpaceWidth: CGFloat = 0.0
    static let btttomBarContenthorizontalStackViewRightSpaceWidth: CGFloat = 0.0
    static let bottomBarcontentHorizontalStackViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 1.6
    
    static let bottomBarContentVerticalStackViewBorderWidth: CGFloat = 1.0
    static let bottomBarContentVerticalStackViewBottomSpace: CGFloat = 0.0
    static let bottomBarContentVerticalStackViewCornerRadius: CGFloat = 16.0
    static let bottomBarContentVerticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.73
    static let bottomBarContentVerticalStackViewTopSpaceHeight: CGFloat = 0.0
    
    static let bottomBarFullHorizontalStackViewRightSpaceWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    static let bottomBarFullHorizontalStackViewSpacing: CGFloat = 0.0
    
    static let bottomBarMenuButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8
    
    static let bottomBarSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 1.10
    
    static let bottomBarTopSpaceHeight: CGFloat = 0.0
    
    static let inputTextViewFontSize: CGFloat = 16.0
    
    static let transferButtonCornerRadius: CGFloat = ((UIScreen.main.bounds.height / 100) * 4.43) / 2
    static let transferButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 9.6
}
