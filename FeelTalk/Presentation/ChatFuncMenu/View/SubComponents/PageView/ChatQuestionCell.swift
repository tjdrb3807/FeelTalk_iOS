//
//  ChatQuestionCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ChatQuestionCellModel {
    let model: Question
    var isTodayQuestion: Bool?
    var isSelected: Bool
}

final class ChatQuestionCell: UITableViewCell {
    let modelObserver = PublishRelay<ChatQuestionCellModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(
            name: CommonFontNameSpace.montserratBold,
            size: ChatQuestionCellNameSpace.indexLabelFontSize)
        label.textAlignment = .center
        label.layer.cornerRadius = ChatQuestionCellNameSpace.indexLabelCornerRadius
        label.clipsToBounds = true
        
        modelObserver
            .map { event -> String in String(event.model.index) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        modelObserver
            .bind { event in
                if event.isTodayQuestion! {
                    label.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main300))
                    label.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500))
                } else {
                    label.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                    label.rx.textColor.onNext(.black)
                }
            }.disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: ChatQuestionCellNameSpace.bodyLabelFontSize)
        
        modelObserver
            .map { event -> String in event.model.body }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: ChatQuestionCellNameSpace.contentViewTopInset,
                left: ChatQuestionCellNameSpace.contentViewLeftInset,
                bottom: ChatQuestionCellNameSpace.contentViewBottomInset,
                right: ChatQuestionCellNameSpace.contentViewRightInset))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .clear
    
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = ChatQuestionCellNameSpace.contentViewCornerRadius
        contentView.layer.borderWidth = ChatQuestionCellNameSpace.contentViewBorderWidth
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: CGRect(
                origin: .zero,
                size: CGSize(
                    width: ChatQuestionCellNameSpace.contentViewShadowWidth,
                    height: ChatQuestionCellNameSpace.contentViewShadowHeight)),
            cornerRadius: ChatQuestionCellNameSpace.contentViewShadowCornerRadius).cgPath
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(ChatQuestionCellNameSpace.contentViewShadowAlpha).cgColor
        contentView.layer.shadowOpacity = ChatQuestionCellNameSpace.contentViewShadowOpacity
        contentView.layer.shadowRadius = ChatQuestionCellNameSpace.contentViewSahdowRadius
        contentView.layer.shadowOffset = CGSize(
            width: ChatQuestionCellNameSpace.contentViewShadowOffsetWidth,
            height: ChatQuestionCellNameSpace.contentViewShadowOffsetHeight)
        
        selectionStyle = .none
        
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
        makeIndexLabelConstraints()
        makeBodyLabelConstraints()
    }
}

extension ChatQuestionCell {
    private func addViewSubComponents() {
        [indexLabel, bodyLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeIndexLabelConstraints() {
        indexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChatQuestionCellNameSpace.indexLabelTopInset)
            $0.leading.equalToSuperview().inset(ChatQuestionCellNameSpace.indexLabelLeadingInset)
            $0.bottom.equalToSuperview().inset(ChatQuestionCellNameSpace.indexLabelBottomInset)
            $0.width.equalTo(indexLabel.snp.height)
        }
    }
    
    private func makeBodyLabelConstraints() {
        bodyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(indexLabel.snp.trailing).offset(ChatQuestionCellNameSpace.bodyLabelLeaindOffset)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatQuestionCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatQuestionCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width,
                height: ChatQuestionCellNameSpace.height,
                alignment: .center)
    }
    
    struct ChatQuestionCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = ChatQuestionCell()
            c.modelObserver
                .accept(ChatQuestionCellModel(
                    model: Question(index: 1, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                    isTodayQuestion: true,
                    isSelected: false))
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
