//
//  PartnerInfoBreakUpButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit

final class PartnerInfoBreakUpButton: UIButton {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = PartnerInfoBreakUpButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_my_page_gear")  // TODO: 디자인 변경
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var breakUpLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerInfoBreakUpButtonNameSpace.breakUpLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: PartnerInfoBreakUpButtonNameSpace.breakUpLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        backgroundColor = .white
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray200)?.cgColor
        layer.borderWidth = PartnerInfoBreakUpButtonNameSpace.borderWidth
        layer.cornerRadius = PartnerInfoBreakUpButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponent()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeRightImageViewConstraints()
    }
}

extension PartnerInfoBreakUpButton {
    private func addViewSubComponent() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(PartnerInfoBreakUpButtonNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(PartnerInfoBreakUpButtonNameSpace.contentStackViewLeadingInset)
            $0.bottom.equalToSuperview().inset(PartnerInfoBreakUpButtonNameSpace.conetntStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [rightImageView, breakUpLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeRightImageViewConstraints() {
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(PartnerInfoBreakUpButtonNameSpace.rightImageViewWidth)
            $0.height.equalTo(PartnerInfoBreakUpButtonNameSpace.rightImageViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerInfoBreakUpButton_Previews: PreviewProvider {
    static var previews: some View {
        PartnerInfoBreakUpButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (PartnerInfoBreakUpButtonNameSpace.leadingInset + PartnerInfoBreakUpButtonNameSpace.trailingInset),
                   height: PartnerInfoBreakUpButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct PartnerInfoBreakUpButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PartnerInfoBreakUpButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}


#endif
