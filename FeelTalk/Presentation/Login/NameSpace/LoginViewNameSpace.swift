//
//  LoginViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import UIKit

enum LoginViewNameSpace {
    static let loginViewBackgroundColor: String = "gray_100"
    
    static let introductionVerticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 1.72
    static let introductionVerticalSatckViewTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 18.22
    static let introductionVerticalStackViewLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8
    static let introductionVerticalStackViewTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.33
    
    static let feelTalkImageViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 30.4
    
    static let introductionText: String = """
                                            연인들의 건강하고
                                            즐거운 대화, 필로우톡
                                            """
    static let introductionLableFont: String = "pretendard-regular"
    static let introductionLabelSize: CGFloat = 24.0
    static let introductionLabelLines: Int = 0
    static let introductionLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98
    
    static let emphasisText: String = "필로우톡"
    static let emphasisFont: String = "pretendard-bold"
    
    static let loginButtonVerticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98
    static let loginButtonVerticalStackViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 9.60
    static let loginButtonVerticalStackViewLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
}
