//
//  ChatChallengeCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ChatChallengeCellModel {
    let model: Challenge
    var isSelected: Bool
}

final class ChatChallegeCell: UICollectionViewCell {
    let modelObserver = PublishRelay<ChatChallengeCellModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = ChatChallengeCellNameSpace.dDayLabelCornerRadius
        label.clipsToBounds = true
        
        modelObserver
            .map { event -> String in event.model.deadline! }
            .map { String.replaceT($0) }
            .bind {
                guard let deadline = Date.strToDate($0) else { return }
                let dDay = Utils.calculateDday(deadline)
                
                label.rx.text.onNext(dDay)
                
                let interval = Int(deadline.timeIntervalSince(Date()) / 86400) + 1
                
                if interval <= 7 {
                    label.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                                                size: ChatChallengeCellNameSpace.dDayLabelFontSize))
                    label.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main300))
                    label.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500))
                } else {
                    label.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular,
                                                size: ChatChallengeCellNameSpace.dDayLabelFontSize))
                    label.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                    label.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
                }
            }.disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = ChatChallengeCellNameSpace.titleLabelNumberOfLines
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardSemiBold,
            size: ChatChallengeCellNameSpace.titleLabelFontSize)
        
        modelObserver
            .map { event -> String? in event.model.title }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: ChatChallengeCellNameSpace.nicknameLabelFontSize)
        
        modelObserver
            .map { event -> String? in event.model.creator }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: ChatChallengeCellNameSpace.width,
                    height: ChatChallengeCellNameSpace.height)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = ChatChallengeCellNameSpace.contentViewCornerRadius
        contentView.layer.borderWidth = ChatChallengeCellNameSpace.contentViewBorderWidth
        
        layer.cornerRadius = ChatChallengeCellNameSpace.cornerRadius
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: ChatChallengeCellNameSpace.shadowCornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(ChatChallengeCellNameSpace.shadowAlpha).cgColor
        layer.shadowOpacity = ChatChallengeCellNameSpace.shadowOpacity
        layer.shadowRadius = ChatChallengeCellNameSpace.shadowRadius
        layer.shadowOffset = CGSize(
            width: ChatChallengeCellNameSpace.shadowOffsetWidth,
            height: ChatChallengeCellNameSpace.shadowOffsetHeight)
        
        modelObserver
            .map { event -> Bool in event.isSelected }
            .map { state -> UIColor in state ? UIColor(named: CommonColorNameSpace.main500)! : UIColor.clear }
            .map { color -> CGColor in color.cgColor }
            .bind(to: contentView.layer.rx.borderColor)
            .disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeDdayLabelConstraints()
        makeTitleLabelConstraints()
        makeNicknameLabelConstraints()
    }
}

extension ChatChallegeCell {
    private func addViewSubComponents() {
        [dDayLabel, titleLabel, nicknameLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeDdayLabelConstraints() {
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChatChallengeCellNameSpace.dDayLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.width.equalTo(ChatChallengeCellNameSpace.dDayLabelWidth)
            $0.height.equalTo(ChatChallengeCellNameSpace.dDayLabelHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(ChatChallengeCellNameSpace.titleLabelTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeNicknameLabelConstraints() {
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.bottom.equalToSuperview().inset(ChatChallengeCellNameSpace.nicknameLabelBottomInset)
            $0.height.equalTo(ChatChallengeCellNameSpace.nicknameHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatChallegeCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatChallegeCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: ChatChallengeCellNameSpace.width,
                height: ChatChallengeCellNameSpace.height,
                alignment: .center)
    }
    
    struct ChatChallegeCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = ChatChallegeCell()
            c.modelObserver
                .accept(ChatChallengeCellModel(
                    model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                    isSelected: false))
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
