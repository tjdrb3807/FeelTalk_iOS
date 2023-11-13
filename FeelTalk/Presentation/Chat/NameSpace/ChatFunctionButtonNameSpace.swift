//
//  ChatFunctionButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/12.
//

import Foundation

enum ChatFunctionButtonNameSpace {
    // ChatFunctionButton
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 23.46                     // 88.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 14.40                      // 117.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98      // 8.0
    
    // ContentImageView
    static let contentImageViewCameraTypeImage: String = "icon_camera"
    static let contentImageViewAlbumTypeImage: String = "icon_album"
    static let contentImageViewCornerRadius: CGFloat = contentImageViewHeight / 2
    static let contentImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.83      // 88.0
    
    // ContentTitleLabel
    static let contentTitleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73  // 14.0
    static let contentTitleLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58      // 21.0
}
