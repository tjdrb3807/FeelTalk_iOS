//
//  QuestionTableSectionHeaderView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import UIKit
import SnapKit

final class QuestionTableSectionHeaderView: UITableViewHeaderFooterView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTableSectionHeaderViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: QuestionTableSectionHeaderViewNameSpace.titleLabelTextFont,
                            size: QuestionTableSectionHeaderViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func addSubComponents() {
        contentView.addSubview(titleLabel)
    }
    
    private func setConfigurations() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(QuestionTableSectionHeaderViewNameSpace.titleLabelLeadingInset)
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionTableSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTableSectionHeaserView_Presentable()
    }
    
    struct QuestionTableSectionHeaserView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionTableSectionHeaderView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
