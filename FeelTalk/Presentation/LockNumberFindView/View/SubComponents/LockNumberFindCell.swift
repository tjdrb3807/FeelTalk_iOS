//
//  LockNumberFindCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import UIKit
import SnapKit

final class LockNumberFindCell: UIButton {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberFindCellNameSpace.contentStackViewSpacing
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberFindCellNameSpace.titleTextSize)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberFindCellNameSpace.descriptionLabelTextSize)
        
        return label
    }()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        self.title.text = title
        self.title.setLineHeight(height: LockNumberFindCellNameSpace.titleLineHeight)
        self.descriptionLabel.text = description
        self.descriptionLabel.setLineHeight(height: LockNumberFindCellNameSpace.descriptionLabelLineHeight)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.cornerRadius = LockNumberFindCellNameSpace.cornerRadius
        layer.borderWidth = LockNumberFindCellNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray500)?.cgColor
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubcomponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
    }
}

extension LockNumberFindCell {
    private func addViewSubcomponents() {
        addSubview(contentStackView)
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [title, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberFindCell_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberFindCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width:
                    UIScreen.main.bounds.width - (
                        CommonConstraintNameSpace.leadingInset +
                        CommonConstraintNameSpace.trailingInset),
                   height: LockNumberFindCellNameSpace.height,
                   alignment: .center)
    }
    
    struct LockNumberFindCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockNumberFindCell(
                title: "연인에게 도움 요청하기",
                description: "연인이 암호를 재설정할 수 있는 링크를 보내줘요")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
