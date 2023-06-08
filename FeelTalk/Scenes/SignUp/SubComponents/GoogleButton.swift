//
//  GoogleButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import SnapKit

final class GoogleButton: UIButton {
    private lazy var mainHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_google")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "구글로 계속하기"
        label.font = UIFont(name: "pretendard-bold", size: 15.0)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "google_button_background")
        self.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 6.15) / 2
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [logoImageView, separator, buttonTitleLabel].forEach { mainHorizontalStackView.addArrangedSubview($0) }
    
        separator.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 0.26)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 1.60)
        }
        
        buttonTitleLabel.snp.makeConstraints { $0.width.equalTo((UIScreen.main.bounds.width / 100) * 26.4) }
        
        buttonTitleLabel.snp.makeConstraints { $0.height.equalToSuperview() }
        
        addSubview(mainHorizontalStackView)
        
        mainHorizontalStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton_Presentable()
    }
    
    struct GoogleButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            GoogleButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
