//
//  ChatFuncMenuViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/29.
//

import Foundation

enum ChatFuncMenuViewNameSpace {
    // MARK: CollectionView
    /// 0.0
    static let collectionViewMinimumLineSpacing: CGFloat = 0.0
    /// 0.0
    static let collectionViewMinimunInterItemSpacing: CGFloat = 0.0
    
    // MARK: ShardButton
    /// "공유하기"
    static let shareButtonTitleText: String = "공유하기"
    /// 18.0
    static let shardButtonTitleLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let shareButtonCornerRadius: CGFloat = shareButtonHeight / 2
    /// 59.0
    static let shareButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
}
