//
//  ChatChllengeCVCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/29.
//

import Foundation

enum ChatChallengeCVCellNameSpace {
    // MARK: ChatChallengeCVCell
    /// "ChatChallengeCVCell"
    static let identifier: String = "ChatChallengeCVCell"
    
    // MARK: EmptyInfoView
    /// 182.0
    static let emptyInfoViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 48.53
    /// 233.0
    static let emptyInfoViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 28.69
    
    // MARK: CollectionView
    /// 16.0
    static let collectionViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 15.0
    static let collectionViewMinimumLineSpace: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.84
    /// 15.0
    static let collecitonViewMinimumInteritemSpace: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.0
    /// 74.0
    static let collectionViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.11
}
