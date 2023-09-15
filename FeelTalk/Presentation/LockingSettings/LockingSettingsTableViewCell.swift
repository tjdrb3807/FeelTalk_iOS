//
//  LockingSettingsTableViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit

final class LockingSettingsTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "화면잠금"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubComponents() {
        [titleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
    }
}

extension LockingSettingsTableViewCell {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingSettingsTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        LockingSettingsTableViewCell_Presentable()
    }
    
    struct LockingSettingsTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockingSettingsTableViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
