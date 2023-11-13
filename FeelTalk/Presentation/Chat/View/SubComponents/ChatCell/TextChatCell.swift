//
//  TextChatCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TextChatCell: UICollectionViewCell {
    let model = PublishRelay<TextChatModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var verticalContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = TextChatCellNameSapce.verticalContentStckViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var partnerInfo: ChatPartnerInfoView = { ChatPartnerInfoView() }()
    
    private lazy var horizontalContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .init(top: TextChatCellNameSapce.messageTextViewContainerTopInset,
                                            left: TextChatCellNameSapce.messageTextViewContainerLeftInset,
                                            bottom: TextChatCellNameSapce.messageTextViewContainerBottomInset,
                                            right: TextChatCellNameSapce.messageTextViewContainerRightInset)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.layer.cornerRadius = TextChatCellNameSapce.messageTextViewCornerRadius
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.clipsToBounds = true
        
        return textView
    }()
    
    private lazy var supplementContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var isReadStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var imageView: UIImageView = { // TODO: 이름 변경
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.setVerticalContentStackViewProperties(with: model)
                v.addVerticalContentStackViewSubComponents(with: model)
                if !model.isMine { v.partnerInfo.snp.makeConstraints { $0.height.equalTo(28) } }
                v.setHorizontalContentStackViewProperties(with: model)
                v.addHorizontalContetnStackViewSubComponents(with: model)
                v.setMessageTextViewProperties(with: model)
                v.makeMessageTextViewConstraints()
                v.setSupplementContentStackViewProperties(with: model)
                v.addSupplementContentStackViewSubComponents()
                v.setIsReadStateLabelProperties(with: model)
                v.setTiemLabelProperties(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .cyan
    }
    
    private func addSubComponents() {
        contentView.addSubview(verticalContentStackView)
    }
    
    private func setConstraints() {
        verticalContentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
}

extension TextChatCell {
    private func setVerticalContentStackViewProperties(with model: TextChatModel) {
        model.isMine ? verticalContentStackView.rx.alignment.onNext(.trailing) : verticalContentStackView.rx.alignment.onNext(.leading)
    }
    
    private func addVerticalContentStackViewSubComponents(with model: TextChatModel) {
        model.isMine ?
        verticalContentStackView.addArrangedSubview(horizontalContentStackView) :
        [partnerInfo, horizontalContentStackView].forEach { verticalContentStackView.addArrangedSubview($0) }
    }
    
    private func setHorizontalContentStackViewProperties(with model: TextChatModel) {
        model.isMine ?
        horizontalContentStackView.rx.spacing.onNext(TextChatCellNameSapce.horizontalContentStackViewMyChatTypaSpacing) :
        horizontalContentStackView.rx.spacing.onNext(TextChatCellNameSapce.horizontalContentStackViewPartnerChatTypeSpacing)
    }
    
    private func addHorizontalContetnStackViewSubComponents(with model: TextChatModel) {
        model.isMine ?
        [supplementContentStackView, messageTextView].forEach { horizontalContentStackView.addArrangedSubview($0) } :
        [messageTextView, supplementContentStackView].forEach { horizontalContentStackView.addArrangedSubview($0) }
    }
    
    private func setMessageTextViewProperties(with model: TextChatModel) {
        messageTextView.setLineAndLetterSpacing(model.message)
        messageTextView.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular,
                                              size: TextChatCellNameSapce.messageTextViewTextSize))
        
        if model.isMine {
            messageTextView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
            messageTextView.rx.textColor.onNext(.white)
        } else {
            messageTextView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray100))
            messageTextView.rx.textColor.onNext(.black)
        }
    }
    
    private func makeMessageTextViewConstraints() {
        messageTextView.intrinsicContentSize.width > TextChatCellNameSapce.messageTextViewMaxWidth ?
        messageTextView.snp.makeConstraints { $0.width.equalTo(TextChatCellNameSapce.messageTextViewMaxWidth) } :
        messageTextView.snp.makeConstraints { $0.width.equalTo(messageTextView.intrinsicContentSize.width) }
    }
    
    private func setSupplementContentStackViewProperties(with model: TextChatModel) {
        model.isMine ?
        supplementContentStackView.rx.alignment.onNext(.trailing) :
        supplementContentStackView.rx.alignment.onNext(.leading)
    }
    
    private func addSupplementContentStackViewSubComponents() {
        [isReadStateLabel, timeLabel].forEach { supplementContentStackView.addArrangedSubview($0) }
    }
    
    private func setIsReadStateLabelProperties(with model: TextChatModel) {
        let stateString = model.isRead ? "읽음" : "안읽음"
        
        isReadStateLabel.rx.text.onNext(stateString)
        isReadStateLabel.setLineHeight(height: 18)
    }
    
    private func setTiemLabelProperties(with model: TextChatModel) {
        timeLabel.rx.text.onNext(model.createAt)
        isReadStateLabel.setLineHeight(height: 18)
    }
}

#if DEBUG

import SwiftUI

struct TextChatCell_Previews: PreviewProvider {
    static var previews: some View {
        TextChatCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 0,
                   alignment: .center)
    }
    
    struct TextChatCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = TextChatCell()
            v.model.accept(.init(index: 0,
                                 type: .textChatting,
                                 isMine: true,
                                 isRead: true,
                                 isSend: true,
                                 createAt: "04:44",
                                 chatLocation: .first,
                                 message: "grapes vanilla carnival florence marshmallow cresent serendipity flutter like laptop way bijou lovable charming."))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
