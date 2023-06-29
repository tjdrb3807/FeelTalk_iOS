//
//  ChallengeViewTabBarButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/16.
//

import UIKit
import SnapKit

final class ChallengeViewTabBarButton: UIButton {
    var tabBarItemType: ChallengeTabItem
    
    private lazy var labelHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.06
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var tabBarButtonTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = tabBarItemType.titleText
        label.font = UIFont(name: "pretendard-bold", size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "999"
        label.font = UIFont(name: "pretendard-bold", size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var stateBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    init(tabBarItemType: ChallengeTabItem) {
        self.tabBarItemType = tabBarItemType
        super.init(frame: .zero)
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [tabBarButtonTitleLabel, countLabel].forEach { labelHorizontalStackView.addArrangedSubview($0) }
        
        tabBarButtonTitleLabel.snp.makeConstraints { $0.width.equalTo(tabBarButtonTitleLabel.intrinsicContentSize) }
        
        countLabel.snp.makeConstraints { $0.width.equalTo(countLabel.intrinsicContentSize) }
        
        [labelHorizontalStackView, stateBar].forEach { addSubview($0) }
        
        labelHorizontalStackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        stateBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 0.12)
        }
        
    }
    
    func setTitleColor(_ color: UIColor) { self.tabBarButtonTitleLabel.textColor = color }
    func setCountColor(_ color: UIColor) { self.countLabel.textColor =  color }
    func setStateColor(_ color: UIColor) { self.stateBar.backgroundColor = color}
}

#if DEBUG

import SwiftUI

struct ChallengeViewTabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewTabBarButton_Presentable()
    }
    
    struct ChallengeViewTabBarButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeViewTabBarButton(tabBarItemType: .want)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif


