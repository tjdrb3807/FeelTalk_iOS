//
//  ChallengeCollectionViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/27.
//

import Foundation

enum ChallengeCollectionViewCellNameSpace {
    // ChallengeCollectionViewCell
    static let identifier: String = "ChallengeCollectionViewCell"
    
    // CollectionView
    static let collectionViewMinLineSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.84         // 15.0
    static let collectionViewMinItemSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.0        // 15.0
    static let collectionViewSectionTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97        // 16.0
    static let collectionViewSectionBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97     // 16.0
    static let collectionViewDefaultSectionIndex: Int = 0
}
