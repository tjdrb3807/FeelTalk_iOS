//
//  ChatPartnerInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/17.
//

import UIKit
import SnapKit

final class ChatPartnerInfoView: UIStackView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: CommonColorNameSpace.gray400) // TODO: 변경
        imageView.layer.cornerRadius = 28 / 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var partnerNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = 4
        backgroundColor = .clear
        sizeToFit()
    }
    
    private func addSubComponents() {
        [profileImageView, partnerNicknameLabel].forEach { addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { $0.width.equalTo(28) }
    }
}

#if DEBUG

import SwiftUI

struct ChatPartnerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPartnerInfoView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 28,
                   alignment: .center)
    }
    
    struct ChatPartnerInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatPartnerInfoView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
