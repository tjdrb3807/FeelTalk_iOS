//
//  QuestionInputViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionInputViewController: UIViewController {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 3.94
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var titleLabel = QuestionInputViewTitleLabel()
    private lazy var myAnswerSection = QuestionInputViewMyAnswerSection()
    private lazy var partnerAnswerSection = QuestionInputViewPartnerAnswerSection()
    private lazy var answerSuccessButton = QuestionInputViewAnswerSuccessButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
    }
    
    private func setConfig() {
        [titleLabel, myAnswerSection, partnerAnswerSection].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 8.86) }
        
        myAnswerSection.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 20.44) }
        
        partnerAnswerSection.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26) }
        
        [totalVerticalStackView, answerSuccessButton].forEach { view.addSubview($0) }
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 7.51)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
        }
        
        answerSuccessButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(totalVerticalStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26)
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionInputViewController_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct QuestionInputViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            QuestionInputViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
