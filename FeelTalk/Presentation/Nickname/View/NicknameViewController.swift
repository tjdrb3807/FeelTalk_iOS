//
//  NicknameViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: UIViewController {
    var viewModel: NicknameViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .signUp) }()
    
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: 2/3) }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NicknameNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: NicknameNameSpace.titleLabelTextFont, size: NicknameNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NicknameNameSpace.descriptionLabelText
        label.textColor = UIColor(named: NicknameNameSpace.descriptionLabelTextColor)
        label.font = UIFont(name: NicknameNameSpace.descriptionLabelTextFont,
                            size: NicknameNameSpace.descriptionLabelTextSize)
        label.lineBreakMode = .byClipping
        label.numberOfLines = NicknameNameSpace.descriptionLabelLineNumber
        label.setLineSpacing(spacing: NicknameNameSpace.descriptionLabelLineSpace)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = NicknameNameSpace.nicknameLabelText
        label.textColor = UIColor(named: NicknameNameSpace.nicknameLabelTextColor)
        label.font = UIFont(name: NicknameNameSpace.nicknameLabelTextFont, size: NicknameNameSpace.nicknameLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var nicknameTextField: CustomTextField01 = { CustomTextField01(placeholder: "연인에게 보여줄 닉네임을 적어주세요",
                                                                                useClearButton: true,
                                                                                textLimit: 10) }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(NicknameNameSpace.nextButtonTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: NicknameNameSpace.nextButtonTitleFont,
                                         size: NicknameNameSpace.nextButtonTitleSize)
        button.backgroundColor = UIColor(named: NicknameNameSpace.nextButtonDeactiveBackgoundColor)
        button.layer.cornerRadius = NicknameNameSpace.nextButtonBaseCornerRadius
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.backgroundColor = .clear
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func bind(to viewModel: NicknameViewModel) {
        let input = NicknameViewModel.Input(nicknameText: nicknameTextField.rx.text.orEmpty.asObservable(),
                                            tapNextButton: nextButton.rx.tap,
                                            tapNavigationBarLeftButton: navigationBar.leftButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.keyboardHeight
            .skip(1)
            .withUnretained(self)
            .bind(onNext: { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeght(height)
            }).disposed(by: disposeBag)
        
        output.nicknameTextError
            .withUnretained(self)
            .bind { vc, error in
                if error == .none {
                    vc.warningLabel.rx.isHidden.onNext(true)
                } else {
                    vc.warningLabel.rx.text.onNext(error.rawValue)
                    vc.warningLabel.rx.isHidden.onNext(false)
                }
            }.disposed(by: disposeBag)
        
        output.activateNextButton
            .withUnretained(self)
            .bind(onNext: { vc, state in
                vc.toggleNextButton(state)
            }).disposed(by: disposeBag)
    }
    
    private func setAttribute()  { view.backgroundColor = .white }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConfiguration() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpFlowNavigationBarNameSpace.navigationBarHeight)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomProgressBarNameSpace.progressBarHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(NicknameNameSpace.titleLabelTopOffset)
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
            $0.height.equalTo(NicknameNameSpace.titleLabelHeight)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(NicknameNameSpace.descriptionLabelTopOffset)
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
            $0.trailing.equalToSuperview().inset(NicknameNameSpace.baseTrailingInset)
            $0.height.equalTo(NicknameNameSpace.descriptionLabelHeight)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(NicknameNameSpace.nicknameTopOffset)
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(NicknameNameSpace.nicknameTextFieldTopOffset)
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
            $0.trailing.equalToSuperview().inset(NicknameNameSpace.baseTrailingInset)
            $0.height.equalTo(NicknameNameSpace.nicknameTextFieldHeight)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(4.0)
            $0.leading.equalTo(nicknameTextField.snp.leading).offset(6)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
            $0.trailing.equalToSuperview().inset(NicknameNameSpace.baseTrailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(NicknameNameSpace.nextButtonHeight)
        }
    }
}

extension NicknameViewController {
    private func addViewSubComponents() {
        [navigationBar, progressBar,
         titleLabel, descriptionLabel,
         nicknameLabel, nicknameTextField, warningLabel,
         nextButton].forEach { view.addSubview($0) }
    }
}

extension NicknameViewController {
    private func updateKeyboardHeght(_ keyboardHeight: CGFloat) {
        if keyboardHeight == 0.0 {
            nextButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight)
                $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
                $0.trailing.equalToSuperview().inset(NicknameNameSpace.baseTrailingInset)
            }
            nextButton.layer.cornerRadius = NicknameNameSpace.nextButtonBaseCornerRadius
        } else {
            nextButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight)
                $0.leading.trailing.equalToSuperview()
            }
            nextButton.layer.cornerRadius = NicknameNameSpace.nextButtonUpdateCornerRadius }
    
        view.layoutIfNeeded()
    }
    
    private func toggleNextButton(_ state: Bool) {
        if state {
            nextButton.rx.backgroundColor.onNext(UIColor(named: NicknameNameSpace.nextButtonActiveBackgroundColor))
        } else {
            nextButton.rx.backgroundColor.onNext(UIColor(named: NicknameNameSpace.nextButtonDeactiveBackgoundColor))
        }
        
        nextButton.rx.isEnabled.onNext(state)
    }
}

#if DEBUG

import SwiftUI

struct NicknameViewController_Previews: PreviewProvider {
    static var previews: some View {
        NicknameViewController_Presentable()
    }

    struct NicknameViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = NicknameViewController()
            let vm = NicknameViewModel(coordinator: DefaultNicknameCoordinator(UINavigationController()),
                                       signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
            
            vc.viewModel = vm
            
            return vc
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
