//
//  HomeTopSectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/10.
//

import UIKit
import SnapKit

final class HomeTopSectionView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 2.46
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_home_note")
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // SubComponents
    lazy var homeNavigationBar = HomeNavigationBarView()
    private lazy var coupleInfoView = HomeCoupleInfoView()
    private lazy var questionArrivedLabel = HomeQuestionArrivedLabel()
    private lazy var questionAnswerButton = HomeQuestionAnswerButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "main_500")
        clipsToBounds = true
        layer.cornerRadius = 20.0
        layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }
    
    private func setConfig() {
        [homeNavigationBar, coupleInfoView, questionArrivedLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        homeNavigationBar.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 6.85)
        }
        
        coupleInfoView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.92)
        }
        
        questionArrivedLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 10.09)
        }
        
        [totalVerticalStackView, questionAnswerButton, backgroundImageView].forEach { addSubview($0) }
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 5.18)
            $0.leading.trailing.equalToSuperview()
        }
        
        questionAnswerButton.snp.makeConstraints {
            $0.top.equalTo(totalVerticalStackView.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 2.46)
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 40.0)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 6.28)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeTopSectionView_Preveiws: PreviewProvider {
    static var previews: some View {
        HomeTopSectionView_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct HomeTopSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeTopSectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
