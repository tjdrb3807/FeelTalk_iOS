//
//  QuestionViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionViewController: UIViewController {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.97
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var navigationBar = QuestionViewNavigationBar()
    private lazy var topSection = QuestionViewTopSection()
    private lazy var bottomSection = QuestionViewBottomSection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttribute()
        self.setConfig()
    }
    
    private func setAttribute() { view.backgroundColor = UIColor(named: "gray_100") }
    
    private func setConfig() {
        [navigationBar, topSection, bottomSection].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.38)
        }
        
        topSection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 25.61)
        }
        
        bottomSection.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
        
        view.addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 5.41)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewController_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct QuestionViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            QuestionViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
