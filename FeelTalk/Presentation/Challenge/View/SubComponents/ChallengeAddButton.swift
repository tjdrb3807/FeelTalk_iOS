//
//  ChallengeAddButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/25.
//

import UIKit
import SnapKit

final class ChallengeAddButton: UIButton {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeAddButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeAddButtonNameSpace.descriptionLabelText
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeAddButtonNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: ChallengeAddButtonNameSpace.descriptionLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ChallengeAddButtonNameSpace.plusImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: ChallengeAddButtonNameSpace.width,
                                              height: ChallengeAddButtonNameSpace.height)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        
        layer.cornerRadius = ChallengeAddButtonNameSpace.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: ChallengeAddButtonNameSpace.shadowCornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(ChallengeAddButtonNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = ChallengeAddButtonNameSpace.shadowOpacity
        layer.shadowRadius = ChallengeAddButtonNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: ChallengeAddButtonNameSpace.shadowOffsetWidth,
                                    height: ChallengeAddButtonNameSpace.shadowOffsetHeight)
    }
    
    private func addSubComponents() {
        addButtonSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() { makeContentStackViewConstraints() }
}

extension ChallengeAddButton {
    private func addButtonSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
        
    private func addContentStackViewSubComponents() {
        [descriptionLabel, plusImageView].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeAddButton_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeAddButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: ChallengeAddButtonNameSpace.width,
                   height: ChallengeAddButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeAddButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeAddButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
