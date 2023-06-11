//
//  HomeSignalButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

enum HomeViewSignalTarget {
    case me
    case partner
}

final class HomeSignalButton: UIButton {
    private var target: HomeViewSignalTarget
    
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.98
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var signalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "gray_300")
        imageView.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 7.88) / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        
        switch target {
        case .me:
            label.text = "me"
        case .partner:
            label.text = "you"
        }
        
        label.font = UIFont(name: "pretendard-regular", size: 16.0)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(target: HomeViewSignalTarget) {
        self.target = target
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = .clear
        
        if target == .partner { isEnabled = false }
    }
    
    private func setConfig() {
        [signalImageView, targetLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        signalImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(signalImageView.snp.width)
        }
        
        targetLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 2.95) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 17.06)
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeSignalButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeSignalButton_Presentable()
    }
    
    struct HomeSignalButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeSignalButton(target: .me)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
