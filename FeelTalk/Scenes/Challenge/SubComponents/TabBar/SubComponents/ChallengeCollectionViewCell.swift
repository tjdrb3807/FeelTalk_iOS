//
//  ChallengeCollectionViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/17.
//

import UIKit
import SnapKit

enum ChallengeCellIndex {
    case first
    case rest
}

final class ChallengeCollectionViewCell: UICollectionViewCell {
    private var cellIndex: ChallengeCellIndex
    
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.98
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "gray_200")
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-999"
        label.textAlignment = .center
        label.textColor = UIColor(named: "main_500")
        label.font = UIFont(name: "pretendard-regular", size: 12.0)
        label.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.69) / 2
        label.backgroundColor = UIColor(named: "main_300")
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 제목챌린지 제목"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "pretendard-bold", size: 16.0)
        
        return label
    }()
    
    private lazy var bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 2.13
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = UIColor(named: "gray_600")
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textAlignment = .left
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_challenge_check"), for: .normal)
        button.backgroundColor = UIColor(named: "gray_200")
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 4.43) / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    init(cellIndex: ChallengeCellIndex) {
        self.cellIndex = cellIndex
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConfig()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
        contentView.clipsToBounds = true
        
        if cellIndex == .first {
            contentView.layer.borderColor = UIColor(named: "main_500")?.cgColor
            contentView.layer.borderWidth = (UIScreen.main.bounds.height / 100) * 0.24
        }
    }
    
    private func setConfig() {
        [categoryImageView, dDayLabel].forEach { topHorizontalStackView.addArrangedSubview($0) }
        
        categoryImageView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 8.53)
            $0.height.equalTo(categoryImageView.snp.width)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 14.93)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.69)
        }
        
        [nicknameLabel, checkButton].forEach { bottomHorizontalStackView.addArrangedSubview($0) }
        
        nicknameLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 2.58) }
        
        checkButton.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 9.6)
            $0.height.equalTo(checkButton.snp.width)
        }
        
        [topHorizontalStackView, challengeTitleLabel, bottomHorizontalStackView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        challengeTitleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
//            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 2.95)
            $0.height.equalTo(challengeTitleLabel.intrinsicContentSize)
        }
        
        contentView.addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 1.47)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 2.46)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCollectionViewCell_Presentable()
    }
    
    struct ChallengeCollectionViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeCollectionViewCell(cellIndex: .first)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
