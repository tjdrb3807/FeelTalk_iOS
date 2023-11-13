//
//  ChatRecordingDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/12.
//

import UIKit
import SnapKit

final class ChatRecordingDescriptionView: UIStackView {
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChatRecordingDescriptionViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ChatRecordingDescriptionViewNameSpace.descriptionLableText
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChatRecordingDescriptionViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = ChatRecordingDescriptionViewNameSpace.spacing
        backgroundColor = UIColor(named: CommonColorNameSpace.main300)
    }
    
    private func addSubComponents() {
        addRecordingDescriptionViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() { makeContentStackViewConstraints() }
}

extension ChatRecordingDescriptionView {
    private func addRecordingDescriptionViewSubComponents() {
        [topSpacing, contentStackView, bottomSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.height.equalTo(ChatRecordingDescriptionViewNameSpace.contentStackViewHeight) }   
    }
    
    private func addContentStackViewSubComponents() {
        [leadingSpacing, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChatRecordingDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRecordingDescriptionView_Presentable()
    }
    
    struct ChatRecordingDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatRecordingDescriptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
