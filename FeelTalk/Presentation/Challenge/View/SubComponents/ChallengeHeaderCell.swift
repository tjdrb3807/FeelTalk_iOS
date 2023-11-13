//
//  ChallengeHeaderCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeHeaderCell: UICollectionViewCell {
    static let id = "ChallengeHeaderCell"
    
    fileprivate let titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(<#T##color: UIColor?##UIColor?#>, for: <#T##UIControl.State#>)
        
        return button
    }()
}
