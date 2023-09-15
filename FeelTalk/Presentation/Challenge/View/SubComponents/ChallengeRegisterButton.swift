//
//  ChallengeRegisterButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit

final class ChallengeRegisterButton: UIButton {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 추가"
        label.textColor = .white
        label.font = UIFont(name: "pretendard-medium",
                            size: 18.0)
        label.setLineHeight(height: 27.0)
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_plus_white")
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: "main_500")
        layer.cornerRadius = 51 / 2
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addButtonSubComponent()
        addStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeStackViewConstraints()
        makePlusImageViewConstratins()
    }
}

extension ChallengeRegisterButton {
    private func addButtonSubComponent() {
        addSubview(stackView)
    }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(20.0)
        }
    }
    
    private func addStackViewSubComponents() {
        [descriptionLabel, plusImageView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func makePlusImageViewConstratins() {
        plusImageView.snp.makeConstraints {
            $0.width.equalTo(20.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeRegisterButton_Preview: PreviewProvider {
    static var previews: some View {
        ChallengeRegisterButton_Presentable()
    }
    
    struct ChallengeRegisterButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeRegisterButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
