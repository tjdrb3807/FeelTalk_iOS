//
//  LockNumberHintPickerCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberHintPickerCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockNumberHintPickerCellNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }
    
    private func addSubComponents() {
        contentView.addSubview(titleLabel)
    }
    
    private func setConstratins() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(LockNumberHintPickerCellNameSpace.titleLabelLeadingInset)
        }
    }
}

extension LockNumberHintPickerCell {
    func setUp(title: String) { titleLabel.rx.text.onNext(title) }
}

#if DEBUG

import SwiftUI

struct LockNumberHintPickerCell_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberHintPickerCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: LockNumberHintPickerCellNameSpace.height,
                   alignment: .center)
    }
    
    struct LockNumberHintPickerCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = LockNumberHintPickerCell()
            c.setUp(title: LockNumberHintType.treasure.convertLabelText())
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
