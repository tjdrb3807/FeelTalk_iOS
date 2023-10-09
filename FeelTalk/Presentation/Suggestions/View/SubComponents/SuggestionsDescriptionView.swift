//
//  SuggestionsDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import UIKit
import SnapKit

final class SuggestionsDescriptionsView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = SuggestionsDescriptionViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: SuggestionsDescriptionViewNameSpace.titleLableTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: SuggestionsDescriptionViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = SuggestionsDescriptionViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.numberOfLines = SuggestionsDescriptionViewNameSpace.descriptionLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SuggestionsDescriptionViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: SuggestionsDescriptionViewNameSpace.descriptionLabelLineHeight)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = SuggestionsDescriptionViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() { [titleLabel, descriptionLabel].forEach { addArrangedSubview($0) } }
    
    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(descriptionLabel.intrinsicContentSize) }
    }
}

#if DEBUG

import SwiftUI

struct SuggestionsDescriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsDescriptionsView_Presentable()
    }
    
    struct SuggestionsDescriptionsView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SuggestionsDescriptionsView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
