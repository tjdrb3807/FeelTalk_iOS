//
//  UserNicknameInputViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class UserNicknameInputViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var labelVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요"
        label.font = UIFont(name: "pretendard-medium", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subscriptLabel: UILabel = {
        let label = UILabel()
        label.text = "연인에게 보여줄 닉네임을 적어주세요."
        label.font = UIFont(name: "pretendard-regular", size: 16.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textFieldVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var textFieldTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont(name: "pretendard-bold", size: 12.0)
        label.textColor = UIColor(named: "gray_500")
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var nicknameInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "pretendard-medium", size: 18.0)
        textField.textColor = .black
        textField.placeholder = "닉네임을 입력해주세요"
        textField.backgroundColor = UIColor(named: "gray_200")
        textField.layer.cornerRadius = 8.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var warningSectionHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.86
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var warningMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_warning")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var warningMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "여러분의 소중한 성생활이 노출되지 않도록 본명이 유추되지 않는 닉네임으로 설정해주세요."
        label.font = UIFont(name: "pretendard-regular", size: 12.0)
        label.textColor = UIColor(named: "gray_500")
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "pretendard-medium", size: 18.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(named: "main_400")
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 7.26) / 2
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        // nextButton 위치 설정
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + view.safeAreaInsets.bottom : 0
                nextButton.snp.updateConstraints {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(height)
                }
                view.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        // 띄어쓰기 방지
        nicknameInputTextField.rx.text.orEmpty.asObservable()
            .scan("") { lastValue, newValue in
                let removedSpaceString = newValue.replacingOccurrences(of: " ", with: "")
                return removedSpaceString.count == newValue.count ? newValue : lastValue
            }.bind(to: nicknameInputTextField.rx.text)
            .disposed(by: disposeBag)
        
        // nextButton 활성화
        nicknameInputTextField.rx.text
            .subscribe(onNext:  { [weak self] in
                guard let self = self else { return }
                if $0 == "" {
                    nextButton.rx.isEnabled.onNext(false)
                    nextButton.rx.backgroundColor.onNext(UIColor(named: "main_400"))
                }
                else {
                    nextButton.rx.isEnabled.onNext(true)
                    nextButton.rx.backgroundColor.onNext(UIColor(named: "main_500"))
                }
            }).disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = CoupleCodeCreateViewConroller()
                navigationController?.pushViewController(viewController.self, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setConfig() {
        [titleLabel, subscriptLabel].forEach { labelVerticalStackView.addArrangedSubview($0) }
        
        [textFieldTitleLabel, nicknameInputTextField].forEach { textFieldVerticalStackView.addArrangedSubview($0) }
        
        nicknameInputTextField.snp.makeConstraints {
            $0.top.equalTo(textFieldTitleLabel.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 0.98)
            $0.leading.trailing.equalToSuperview()
        }
        
        [warningMarkImageView, warningMessageLabel].forEach { warningSectionHorizontalStackView.addArrangedSubview($0) }
        
        [labelVerticalStackView, textFieldVerticalStackView, warningSectionHorizontalStackView, nextButton].forEach { view.addSubview($0) }
        
        labelVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset((UIScreen.main.bounds.height / 100) * 3.57)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.88)
        }
        
        textFieldVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(labelVerticalStackView.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 2.95)
            $0.leading.trailing.equalTo(labelVerticalStackView)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 9.23)
        }
        
        warningSectionHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(textFieldVerticalStackView.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 2.21)
            $0.leading.trailing.equalTo(labelVerticalStackView)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(labelVerticalStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26)
        }
    }
}

#if DEBUG

import SwiftUI

struct UserNicknameInputViewController_Previews: PreviewProvider {
    static var previews: some View {
        UserNicknameInputViewController_Presentable()
    }
    
    struct UserNicknameInputViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UserNicknameInputViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
