//
//  InviteCodeInfoPhraseVIew.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import UIKit
import SnapKit

final class InviteCodeInfoPhraseView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = InviteCodeNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: InviteCodeNameSpace.titleLabelTextFont,
                            size: InviteCodeNameSpace.titleLabelTextSize)
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = InviteCodeNameSpace.descriptionLabelText
        label.textColor = UIColor(named: InviteCodeNameSpace.descriptionLabelTextColor)
        label.font = UIFont(name: InviteCodeNameSpace.descriptionLabelTextFont,
                            size: InviteCodeNameSpace.descriptionLabelTextSize)
        label.setLineSpacing(spacing: InviteCodeNameSpace.descriptionLabelLineSpacing)
        label.textAlignment = .center
        label.numberOfLines = InviteCodeNameSpace.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        self.backgroundColor = .clear
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = InviteCodeNameSpace.inviteCodeInfoPhraseViewSpacing
    }
    
    private func addSubComponents() { [titleLabel, descriptionLabel].forEach { addArrangedSubview($0) } }
    
    private func setConfiguration() {
        
    }
}

extension InviteCodeInfoPhraseView {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.height.equalTo(InviteCodeNameSpace.titleLabelHeight) }
    }
}

#if DEBUG

import SwiftUI

struct InviteCodeInfoPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        InviteCodeInfoPhraseView_Presentable()
    }
    
    struct InviteCodeInfoPhraseView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InviteCodeInfoPhraseView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
