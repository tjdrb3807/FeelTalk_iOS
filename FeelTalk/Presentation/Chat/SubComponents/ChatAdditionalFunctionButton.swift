//
//  ChatAdditionalFunctionButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/03.
//

import UIKit
import SnapKit

enum AdditionalFunctionType {
    case camera
    case album
}

final class ChatAdditionalFunctionButton: UIButton {
    private var additionalFunctionType: AdditionalFunctionType
    
    private lazy var fullVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.98
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var buttomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        switch additionalFunctionType {
        case .camera:
            imageView.image = UIImage(named: "icon_camera")
            imageView.backgroundColor = .white
        case .album:
            imageView.image = UIImage(named: "icon_album")
            imageView.backgroundColor = .black
        }
        
        imageView.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 10.83) / 2
        
        return imageView
    }()
    
    private lazy var buttomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        switch additionalFunctionType {
        case .camera:
            label.text = "카메라"
        case .album:
            label.text = "앨범"
        }
        
        return label
    }()
    
    init(additionalFunctionType: AdditionalFunctionType) {
        self.additionalFunctionType = additionalFunctionType
        super.init(frame: .zero)
        
        self.addSubViews()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [buttomImageView, buttomTitleLabel].forEach { fullVerticalStackView.addArrangedSubview($0) }
        
        addSubview(fullVerticalStackView)
    }
    
    private func setConfig() {
        buttomImageView.snp.makeConstraints {
            $0.width.equalTo(buttomImageView.snp.height)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 10.83)
        }
        
        buttomTitleLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 2.58) }
        
        fullVerticalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatAdditionalFunctionButton_Previews: PreviewProvider {
    static var previews: some View {
        ChatAdditionalFunctionButton_Presentable()
    }
    
    struct ChatAdditionalFunctionButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatAdditionalFunctionButton(additionalFunctionType: .album)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
