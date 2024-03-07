//
//  ChatCellSettingView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/03/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatCellSettingView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 3.0
        
        return stackView
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_chat_reset"), for: .normal)
        
        return button
    }()
    
    private lazy var separatorImage: UIImageView = { UIImageView(image: UIImage(named: "icon_chat_separator")) }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_chat_cancel"), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main100)
        layer.cornerRadius = 24.0 / 2
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
    }
}

extension ChatCellSettingView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [resetButton, separatorImage, cancelButton].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChatCellSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ChatCellSettingView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 51.0,
                height: 24.0,
                alignment: .center)
    }
    
    struct ChatCellSettingView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatCellSettingView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
