//
//  ChatTextMessageCellTest.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/26.
//

import UIKit
import SnapKit

final class ChatTextMessageCell: CustomCollectionViewCell {
    enum ChatType: CaseIterable {
        case partner
        case my
    }
    
    var model: TestChatModel? {
        didSet { bind() }
    }
    
    lazy var fullVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.49
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var contentHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 2.13
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var partnerProfileHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.06
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()

    lazy var partnerProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "gray_600")
        imageView.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.44) / 2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var partnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .black
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.backgroundColor = .clear
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "testMessage"
        textView.font = UIFont(name: "pretendard-regular", size: 16.0)
        textView.layer.cornerRadius = 16.0
//        textView.contentSize = intrinsicContentSize
        
        textView.clipsToBounds = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    lazy var subContentVerticalSatckView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.49
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_chat_like"), for: .normal)
        button.backgroundColor = UIColor(named: "main_300")
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.94) / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var labelHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.06
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor(named: "gray_600")
        label.font = UIFont(name: "pretendard-regular", size: 12.0)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    lazy var readCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "읽음"
        label.textColor = UIColor(named: "gray_600")
        label.font = UIFont(name: "pretendard-regular", size: 12.0)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()

    private func bind() {
        guard let model = model, let font = messageTextView.font else { return }
        
        messageTextView.text = model.message
        let estimatedFrame = model.message.getEstimatedFrame(with: font)
        
        if case .partner = model.chatSender {
            // partnerHorizontalStackView subComponents addSubView, makeConstraints
            [partnerProfileImage, partnerNameLabel].forEach { partnerProfileHorizontalStackView.addArrangedSubview($0) }
            
            partnerProfileImage.snp.makeConstraints { $0.width.equalTo(partnerProfileImage.snp.height) }
            
            // labelHorizontalStackView subComponents addSubView, makeConstraints
            [timeLabel, readCheckLabel].forEach { labelHorizontalStackView.addArrangedSubview($0) }
            
            timeLabel.snp.makeConstraints { $0.width.equalTo(timeLabel.intrinsicContentSize) }
            
            readCheckLabel.snp.makeConstraints { $0.width.equalTo(readCheckLabel.intrinsicContentSize) }
            
            // subContentVerticalStakView subComponents addSubView, makeConstraints
            [likeButton, labelHorizontalStackView].forEach { subContentVerticalSatckView.addArrangedSubview($0) }
            
            likeButton.snp.makeConstraints {
                $0.width.equalTo((UIScreen.main.bounds.width / 100) * 8.53)
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.94)
            }
            
            // subContentVerticalStakView set attribute
            subContentVerticalSatckView.alignment = .leading
            
            // contentHorizontalStackView subComponents addSubView, makeConstraints
            [messageTextView, subContentVerticalSatckView].forEach { contentHorizontalStackView.addArrangedSubview($0) }
            
//            messageTextView.snp.makeConstraints { $0.width.equalTo(messageTextView.intrinsicContentSize) }
            
            // contentHorizontalStackView set attribute
            
            messageTextView.textColor = .black
            messageTextView.backgroundColor = UIColor(named: "gray_200")
            
            // fullVerticalStackView subComponents addSubView and makeConstraints and setAlignment
            fullVerticalStackView.alignment = .leading
            
            [partnerProfileHorizontalStackView, contentHorizontalStackView].forEach { fullVerticalStackView.addArrangedSubview($0) }
            
            partnerProfileHorizontalStackView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.44)
            }
        
            // ChatTextMessageCell contentView subComponent addSubView and makeConstraints
            contentView.addSubview(fullVerticalStackView)
            
            fullVerticalStackView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
                $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 8.0)
            }
        } else {
            // labelHorizontalStackView subComponents addSubView, makeConstraints
            [readCheckLabel, timeLabel].forEach { labelHorizontalStackView.addArrangedSubview($0) }
            
            timeLabel.snp.makeConstraints { $0.width.equalTo(timeLabel.intrinsicContentSize) }
            
            readCheckLabel.snp.makeConstraints { $0.width.equalTo(readCheckLabel.intrinsicContentSize) }
            
            // subContentVerticalStakView subComponents addSubView, makeConstraints
            [likeButton, labelHorizontalStackView].forEach { subContentVerticalSatckView.addArrangedSubview($0) }
            
            likeButton.snp.makeConstraints {
                $0.width.equalTo((UIScreen.main.bounds.width / 100) * 8.53)
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.94)
            }
            
            // subContentVerticalStakView set attribute
            subContentVerticalSatckView.alignment = .trailing
            
            // contentHorizontalStackView subComponents addSubView, makeConstraints
            [subContentVerticalSatckView, messageTextView].forEach { contentHorizontalStackView.addArrangedSubview($0) }
            
//            messageTextView.snp.makeConstraints { $0.width.equalTo(messageTextView.intrinsicContentSize) }
            
            // contentHorizontalStackView set attribute
            messageTextView.textColor = .white
            messageTextView.backgroundColor = UIColor(named: "main_500")
            
            // fullVerticalStackView subComponents addSubView and makeConstraints and setAlignment
            fullVerticalStackView.alignment = .trailing
            
            [partnerProfileHorizontalStackView, contentHorizontalStackView].forEach { fullVerticalStackView.addArrangedSubview($0) }
            
            partnerProfileHorizontalStackView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.44)
            }
        
            // ChatTextMessageCell contentView subComponent addSubView and makeConstraints
            contentView.addSubview(fullVerticalStackView)
            
            fullVerticalStackView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 8.0)
                $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            }
        }
    }
}
