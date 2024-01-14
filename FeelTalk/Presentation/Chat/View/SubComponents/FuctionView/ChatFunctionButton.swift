//
//  ChatFunctionButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/12.
//

import UIKit
import SnapKit

enum ChatFunctionType: String {
    case camera = "카메라"
    case album = "갤러리"
}
final class ChatFunctionButton: UIButton {
    let type: ChatFunctionType
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChatFunctionButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        switch type {
        case .camera:
            imageView.backgroundColor = .white
            imageView.image = UIImage(named: ChatFunctionButtonNameSpace.contentImageViewCameraTypeImage)
        case .album:
            imageView.backgroundColor = .black
            imageView.image = UIImage(named: ChatFunctionButtonNameSpace.contentImageViewAlbumTypeImage)
        }
    
        imageView.layer.cornerRadius = ChatFunctionButtonNameSpace.contentImageViewCornerRadius
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChatFunctionButtonNameSpace.contentTitleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    init(type: ChatFunctionType) {
        self.type = type
        super.init(frame: .zero)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addButtonSubComponrnts()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeContentImageViewConstraints()
        makeContentTitleLabelConstraints()
    }
}

extension ChatFunctionButton {
    private func addButtonSubComponrnts() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.edges.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [contentImageView, contentTitleLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeContentImageViewConstraints() {
        contentImageView.snp.makeConstraints {
            $0.height.equalTo(ChatFunctionButtonNameSpace.contentImageViewHeight)
        }
    }
    
    private func makeContentTitleLabelConstraints() {
        contentTitleLabel.snp.makeConstraints { $0.height.equalTo(ChatFunctionButtonNameSpace.contentTitleLabelHeight) }
    }
}

#if DEBUG

import SwiftUI

struct ChatFunctionButton_Previews: PreviewProvider {
    static var previews: some View {
        ChatFunctionButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: ChatFunctionButtonNameSpace.width,
                   height: ChatFunctionButtonNameSpace.height,
                   alignment: .center)
            
    }
    
    struct ChatFunctionButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatFunctionButton(type: .album)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
