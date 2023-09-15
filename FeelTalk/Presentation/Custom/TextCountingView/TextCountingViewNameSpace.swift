//
//  TextCountingViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/23.
//

import UIKit

enum TextCountingViewNameSpace {
    // MARK: Label
    static let labelTextFont: String = "pretendard-regular"
    static let labelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.46   // 13.0
    static let labelTextColor: String = "gray_400"
    
    // MARK: MolecularLabel
    static let molecularLabelDefaultText: String = "0"
    static let molecularLabelDefaultTextColor: String = "gray_600"
    static let molecularLabelUpdateTextColor: String = "main_500"
    
    // MARK: SlashLabel
    static let slashLabelText: String = "/"
}
