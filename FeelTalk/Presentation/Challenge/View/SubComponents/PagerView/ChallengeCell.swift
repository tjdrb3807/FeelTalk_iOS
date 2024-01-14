//
//  ChallengeCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCell: UICollectionViewCell {
    let model = PublishRelay<Challenge>()
    private let disposeBag = DisposeBag()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeCellNameSpace.dateLabelTextSize)
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        label.layer.cornerRadius = ChallengeCellNameSpace.dateLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeCellNameSpace.titleLabelTextSize)
        label.setLineHeight(height: ChallengeCellNameSpace.titleLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeCellNameSpace.nicknameLabelTextSize)
        label.setLineHeight(height: ChallengeCellNameSpace.nicknameLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: ChallengeCellNameSpace.width,
                                              height: ChallengeCellNameSpace.height)))
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.titleLabel.rx.text.onNext(model.title)
                v.nicknameLabel.rx.text.onNext(model.creator)
                v.dateLabel.rx.text.onNext(model.deadline)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = ChallengeCellNameSpace.cornerRadius
        layer.cornerRadius = ChallengeCellNameSpace.cornerRadius
        layer.borderWidth = ChallengeCellNameSpace.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: ChallengeCellNameSpace.cornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(ChallengeCellNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = ChallengeCellNameSpace.shadowOpacity
        layer.shadowRadius = ChallengeCellNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: ChallengeCellNameSpace.shadowOffsetWidth,
                                    height: ChallengeCellNameSpace.shadowOffsetHeight)
    }
    
    private func addSubComponents() {
        addCellSubComponents()
    }
    
    private func setConstratins() {
        makeDateLabelConstraints()
        makeTitleLabelConstraints()
        makeNicknameLabelConstraints()
    }
}

extension ChallengeCell {
    private func addCellSubComponents() {
        [dateLabel, titleLabel, nicknameLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeDateLabelConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeCellNameSpace.dateLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.width.equalTo(ChallengeCellNameSpace.dateLabelWidth)  // TODO: 진행중과 완료에 따라 넓이 고정값 설정
            $0.height.equalTo(ChallengeCellNameSpace.dateLabelHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(ChallengeCellNameSpace.titleLabelTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func makeNicknameLabelConstraints() {
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.bottom.equalToSuperview().inset(ChallengeCellNameSpace.nicknameLabelBottomInset)
        }
    }
}

extension ChallengeCell {
    private func setDateLabelProperties(isCompleted: Bool, deadLine: String) {
        if isCompleted {
            dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
            dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
        } else {
            /// if 7일 보다 안남았을 경우 {
            /// dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main400)
            /// dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)
            /// } else {
            /// dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
            /// dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200)) }
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: ChallengeCellNameSpace.width,
                   height: ChallengeCellNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeCell()
            v.model.accept(Challenge(index: 0,
                                     pageNo: 0,
                                     title: "첫 번째 챌린지 제목입니다.",
                                     deadline: "2023-11-12",
                                     content: "첫 번째 챌린지 내용",
                                     creator: "전성규",
                                     isCompleted: false))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
