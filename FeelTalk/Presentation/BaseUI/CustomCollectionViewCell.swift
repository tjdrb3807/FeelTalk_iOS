//
//  CustomCollectionViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfig()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfig() {}
}
