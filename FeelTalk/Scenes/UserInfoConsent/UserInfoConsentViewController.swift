//
//  UserInfoConsentViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class UserInfoConsentViewController: UIViewController {
    private let viewModel = UserInfoConsetnViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var totalVertivalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var labelVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.49
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필로우톡을 시작해볼까요?"
        label.font = UIFont(name: "pretendard-medium", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subscriptLabel: UILabel = {
        let label = UILabel()
        label.text = "필로우톡을 이용하시려면 아래의 약관에 동의해주세요."
        label.font = UIFont(name: "pretendard-regular", size: 16.0)
        label.textColor = .black
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
    
    private lazy var infoContentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 4.92
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var sensitiveInfoView = InfoContentView(consentInfoType: .sensitive)
    private lazy var personalInfoView = InfoContentView(consentInfoType: .personal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAttribute()
        self.bindViewModel()
        self.setConfig()
    }
    
    private func bindViewModel() {
        nextButton.rx.tap
            .bind(onNext: {
                let viewController = UserNicknameInputViewController()
                self.navigationController?.pushViewController(viewController.self, animated: true)
            }).disposed(by: disposeBag)
        
        let input = UserInfoConsetnViewModel.Input(
            tapSensitiveInfoTotalCheckButton: sensitiveInfoView.totalCheckButton.rx.tap
                .scan(false) { (lastState, newValue) in
                    !lastState
                }.do(onNext: { [weak self] in
                    guard let self = self else {return }
                    sensitiveInfoView.totalCheckButton.rx.isSelected.onNext($0)
                    addPersonalInfoContentView()
                    sensitiveInfoView.totalCheckButton.rx.isUserInteractionEnabled.onNext(false) //MARK: 다른 방법으로 이미지 변경할 수 있도록 구현
                }),
            tapPersonalInfoTaotalCheckButton: personalInfoView.totalCheckButton.rx.tap
                .asObservable()
                .scan(false) { (lastState, newValue) in
                    !lastState
                }.do(onNext: { [weak self] in
                    guard let self = self else { return }
                    personalInfoView.totalCheckButton.rx.isSelected.onNext($0)
                    addPersonalInfoContentView()
                })
        )
        
        let output = viewModel.transform(input: input)
        
        output.activeNextButton
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                nextButton.rx.isEnabled.onNext($0)
                if $0 == true {
                    nextButton.rx.backgroundColor.onNext(UIColor(named: "main_500"))
                } else {
                    nextButton.rx.backgroundColor.onNext(UIColor(named: "main_400"))
                }
            }).disposed(by: disposeBag)
    }
    
    private func setConfig() {
        [titleLabel, subscriptLabel].forEach { labelVerticalStackView.addArrangedSubview($0) }
        
        infoContentVerticalStackView.addArrangedSubview(sensitiveInfoView)
        
        [labelVerticalStackView, infoContentVerticalStackView, nextButton].forEach { totalVertivalStackView.addArrangedSubview($0) }
        
        labelVerticalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 100 * 6.15)
        }

        infoContentVerticalStackView.snp.makeConstraints {
            $0.left.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-(UIScreen.main.bounds.height / 100) * 12.80)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26)
        }
        
        view.addSubview(totalVertivalStackView)
        
        totalVertivalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset((UIScreen.main.bounds.height / 100) * 3.57)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func addPersonalInfoContentView() {
        infoContentVerticalStackView.addArrangedSubview(personalInfoView)
    }
    
    private func setNavigationBarAttribute(){
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "회원가입"
    }
}

#if DEBUG

import SwiftUI

struct UserInfoConsentViewController_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoConsentViewController_Presentable()
    }
    
    struct UserInfoConsentViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UserInfoConsentViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
