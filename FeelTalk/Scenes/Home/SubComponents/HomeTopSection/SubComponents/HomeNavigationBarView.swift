//
//  HomeNavigationBarView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

final class HomeNavigationBarView: UIView {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_feeltalk")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var pushAlarmViewButton: UIButton = {
        let button = UIButton()
        //TODO: 디자이너에게 부탁해서 read 이미지구해 변경하기
        button.setImage(UIImage(named: "icon_white_alarm_unread"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var pushChatViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_white_chat"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() { backgroundColor = UIColor(named: "main_500") }
    
    private func setConfig() {
        [logoImageView, pushAlarmViewButton, pushChatViewButton].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        pushAlarmViewButton.snp.makeConstraints { $0.trailing.equalTo(pushChatViewButton.snp.leading).offset(-(UIScreen.main.bounds.width / 100) * 6.66) }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 3.2)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBarView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct HomeNavigationBarView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeNavigationBarView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
