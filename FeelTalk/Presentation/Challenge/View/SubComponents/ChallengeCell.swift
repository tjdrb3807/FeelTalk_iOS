//
//  ChallengeCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import UIKit
import SnapKit

final class ChallengeCell: UICollectionViewCell {
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeCellNameSpace.totalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeCellNameSpace.topStackViewSpaing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: ChallengeCellNameSpace.categoryImageViewBackgroundColor)
        imageView.layer.cornerRadius = ChallengeCellNameSpace.categoryImageViewCornerRadius
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-999"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: ChallengeCellNameSpace.dDayLabelTextFont,
                            size: ChallengeCellNameSpace.dDayLabelTextSize)
        label.backgroundColor = UIColor(named: ChallengeCellNameSpace.dDayLabelBackgroundColor)
        label.layer.cornerRadius = ChallengeCellNameSpace.dDayLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeCellNameSpace.middleStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 제목챌린지 제목"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: ChallengeCellNameSpace.titleLabelTextFont,
                            size: ChallengeCellNameSpace.titleLabelTextSize)
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .clear
        label.setLineSpacing(spacing: ChallengeCellNameSpace.titleLabelLineSpacing)
        label.setLineHeight(height: ChallengeCellNameSpace.titleLabelLineHeight)
        label.numberOfLines = ChallengeCellNameSpace.titleLabelNumberOfLines
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var creatorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = UIColor(named: ChallengeCellNameSpace.creatorNameLabelTextColor)
        label.textAlignment = .left
        label.font = UIFont(name: ChallengeCellNameSpace.creatorNameLabelTextFont,
                            size: ChallengeCellNameSpace.creatorNameLabelTextSize)
        label.setLineHeight(height: ChallengeCellNameSpace.creatorNameLabelLineHeight)
        label.numberOfLines = ChallengeCellNameSpace.creatorNameLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var challengeCompleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChallengeCellNameSpace.challengeCompletedButtonImage),
                        for: .normal)
        button.backgroundColor = UIColor(named: ChallengeCellNameSpace.challengeCompletedButtonBackgroundColor)
        button.layer.borderWidth = ChallengeCellNameSpace.challengeCompletedButtonBorderWidth
        button.layer.borderColor = UIColor(named: ChallengeCellNameSpace.challengeCompletedButtonBorderColor)?.cgColor
        button.layer.cornerRadius = ChallengeCellNameSpace.challengeCompletedButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: ChallengeCellNameSpace.backgroundColor)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = ChallengeCellNameSpace.contentViewCornerRadius
        contentView.clipsToBounds = true
    }
    
    private func addSubComponents() {
        addContentViewSubComponent()
        addTotalStackViewSubComponents()
        addTopStackViewSubComponents()
        addMiddleStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeContentViewConstraints()
        makeTotalStackViewConstraints()
        makeTopStackViewConstraint()
        makeCategoryImageViewConstraint()
        makeChallengeCompleteButtonConstraints()
    }
}

extension ChallengeCell {
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ChallengeCellNameSpace.contentViewWidth)
            $0.height.equalTo(ChallengeCellNameSpace.contentViewHeight)
        }
    }
    
    private func addContentViewSubComponent() {
        [totalStackView, challengeCompleteButton].forEach { contentView.addSubview($0) }
    }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(ChallengeCellNameSpace.totalStackViewTopOffset)
            $0.leading.equalTo(contentView).offset(ChallengeCellNameSpace.totalStackViewLeadingOffset)
            $0.trailing.equalTo(contentView).offset(ChallengeCellNameSpace.totalStackViewTrailingOffset)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [topStackView, middleStackView].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeTopStackViewConstraint() {
        topStackView.snp.makeConstraints { $0.height.equalTo(ChallengeCellNameSpace.topStackViewHeight) }
    }
    
    private func addTopStackViewSubComponents() {
        [categoryImageView, dDayLabel].forEach { topStackView.addArrangedSubview($0) }
    }
    
    private func makeCategoryImageViewConstraint() {
        categoryImageView.snp.makeConstraints { $0.width.equalTo(ChallengeCellNameSpace.categoryImageViewWidth) }
    }
    
    private func addMiddleStackViewSubComponents() {
        [titleLabel, creatorNameLabel].forEach { middleStackView.addArrangedSubview($0) }
    }
    
    private func makeChallengeCompleteButtonConstraints() {
        challengeCompleteButton.snp.makeConstraints {
            $0.top.equalTo(challengeCompleteButton.snp.bottom).offset(-ChallengeCellNameSpace.challengeCompletedButtonHeight)
            $0.leading.equalTo(challengeCompleteButton.snp.trailing).offset(-ChallengeCellNameSpace.challengeCompletedButtonWidth)
            $0.trailing.equalTo(totalStackView.snp.trailing)
            $0.bottom.equalTo(contentView).offset(ChallengeCellNameSpace.challengeCompletedButtonBottomOffset)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCell_Presentable()
    }
    
    struct ChallengeCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
