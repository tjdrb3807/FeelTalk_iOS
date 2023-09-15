//
//  ChallengeDetailToolbarBannerCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/25.
//

import UIKit
import SnapKit

final class ChallengeDetailToolbarBannerCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: ChallengeDetailToolbarBannerCellNameSpace.labelTextDefaultFont,
                            size: ChallengeDetailToolbarBannerCellNameSpace.labelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubComponents() {
        contentView.addSubview(label)
    }
    
    private func setConfigurations() {
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setData(with data: ChallengeToolbarBannerContent) {
        self.label.text = data.title
        self.label.asFont(targetString: data.highlight,
                          font: UIFont(name: ChallengeDetailToolbarBannerCellNameSpace.labelTextHighlightFont,
                                       size: ChallengeDetailToolbarBannerCellNameSpace.labelTextSize)!)
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailToolbarBannerCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailToolbarBannerCell_Presentable()
    }
    
    struct ChallengeDetailToolbarBannerCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailToolbarBannerCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
