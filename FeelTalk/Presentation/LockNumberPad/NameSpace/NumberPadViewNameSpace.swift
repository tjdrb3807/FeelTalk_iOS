//
//  NumberPadViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum NumberPadViewNameSpace {
    // MARK: NumberPadView
    /// 280.0
    static let height: CGFloat = NumberPadViewCellNameSpace.height * 4
    /// 292.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 35.96
    
    // MARK: Layout
    /// 0.0
    static let minimumLineSpacing: CGFloat = 0.0
    /// 0,0
    static let minimumInteritemSpacing: CGFloat = 0.0
}
