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
import RxGesture

final class ChallengeCell: UICollectionViewCell {
    let model = PublishRelay<Challenge>()
    let selectedModel = PublishRelay<Challenge>()
    let selectedCellItemsIndex = PublishRelay<Int>()
    var itemsIndex: Int?
    private let disposeBag = DisposeBag()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = ChallengeCellNameSpace.dateLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = ChallengeCellNameSpace.titleLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeCellNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeCellNameSpace.nicknameLabelTextSize)
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
        
        model
            .withUnretained(self)
            .bind { c, model in
                guard let title = model.title,
                      let deadlineStr = model.deadline,
                      let creator = model.creator,
                      let isCompleted = model.isCompleted else { return }
                
                if isCompleted {    // 완료된 챌린지 dataLabel 세팅
                    guard let completedDate = model.completeDate else { return }
                    
                    c.dateLabel.rx.text.onNext(c.convertCompletedDate(date: completedDate))
                    c.dateLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular, size: ChallengeCellNameSpace.dateLabelTextSize))
                    c.dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
                    c.dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                    c.dateLabel.snp.makeConstraints { $0.width.equalTo(ChallengeCellNameSpace.dateLabelCompletedTypeWidth) }
                    
                } else {  // 진행중인 챌린지 dataLabel 세팅
                    let deadlineStr = String.replaceT(deadlineStr)
                    guard let deadline = Date.strToDate(deadlineStr) else { return }
                    let dDay = Utils.calculateDday(deadline)
                    
                    c.dateLabel.rx.text.onNext(dDay)
                    c.dateLabel.snp.makeConstraints { $0.width.equalTo(ChallengeCellNameSpace.dateLabelOngoingTypeWidth) }
                    
                    let interval = Int(deadline.timeIntervalSince(Date()) / 86400) + 1
                    
                    if interval <= 7 {  // D-day가 일주일 이내인 경우
                        c.dateLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                                                          size: ChallengeCellNameSpace.dateLabelTextSize))
                        c.dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main300))
                        c.dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500))
                    } else {
                        c.dateLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular,
                                                          size: ChallengeCellNameSpace.dateLabelTextSize))
                        c.dateLabel.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                        c.dateLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
                    }
                }
                
                c.titleLabel.rx.text.onNext(title)
                c.titleLabel.setLineHeight(height: ChallengeCellNameSpace.titleLabelLineHeight)
                c.nicknameLabel.rx.text.onNext(creator)
            }.disposed(by: disposeBag)
        
        rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(model)
            .bind(to: selectedModel)
            .disposed(by: disposeBag)
        
        rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .compactMap { c, _ in c.itemsIndex }
            .bind(to: selectedCellItemsIndex)
            .disposed(by: disposeBag)
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
    private func calculateDday(targetDate: Date, fromDate: Date) -> Int {
        return Int(targetDate.timeIntervalSince(fromDate) / 86400) + 1
    }
    
    /// ChallengeCell.dateLabel.text에 적용될 completeDate 형식 변환
    /// - Parameter date: "yyyy-MM-ddThh:mm:ss"
    /// - Returns: "yy.MM.dd"
    private func convertCompletedDate(date: String) -> String {
        let yearStartIndex = date.index(date.startIndex, offsetBy: 2)
        let yearEndIndex = date.index(date.startIndex, offsetBy: 3)
        let yearStr = String(date[yearStartIndex...yearEndIndex])
        
        let monthStartIndex = date.index(date.startIndex, offsetBy: 5)
        let monthEndIndex = date.index(date.startIndex, offsetBy: 6)
        let monthStr = String(date[monthStartIndex...monthEndIndex])
        
        let dayStartIndex = date.index(date.startIndex, offsetBy: 8)
        let dayEndIndex = date.index(date.startIndex, offsetBy: 9)
        let dayStr = String(date[dayStartIndex...dayEndIndex])
        
        return "\(yearStr).\(monthStr).\(dayStr)"
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
                                     deadline: Optional("2024-02-01T00:00:00"),
                                     content: "첫 번째 챌린지 내용",
                                     creator: "KakaoSG",
                                     isCompleted: Optional(true),
                                     completeDate: "2024-04-02T00:00:00"))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
