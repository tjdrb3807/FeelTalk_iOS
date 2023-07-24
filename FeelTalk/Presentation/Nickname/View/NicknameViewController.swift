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
    private var viewModel: NicknameViewModel!
    private let disposeBag = DisposeBag()
    
    var signUpInfo: SignUpInfo?
    
    // MARK: SubComponents
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(viewType: .signUp) }()
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
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NicknameNameSpace.nicknameTextFieldPlaceholder
        textField.textColor = .black
        textField.backgroundColor = UIColor(named: NicknameNameSpace.nicknameTextFieldBackgroundColor)
        textField.layer.cornerRadius = NicknameNameSpace.nicknameTextFieldCornerRadius
        
        let paddingView = UIView(frame: CGRect(origin: .zero,
                                               size: CGSize(width: NicknameNameSpace.nicknameTextFieldLeftPadding,
                                                            height: NicknameNameSpace.nicknameTextFieldHeight)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
        self.bind(to: viewModel)
    }
    
    final class func create(with viewModel: NicknameViewModel) -> NicknameViewController {
        let viewController = NicknameViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func bind(to viewModel: NicknameViewModel) {
        let input = NicknameViewModel.Input(inputNickname: nicknameTextField.rx.text.orEmpty,
                                            tapNextButton: nextButton.rx.tap.map { _ in self.signUpInfo }.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.activateNextButton
            .withUnretained(self)
            .bind(onNext: { vc, state in
                vc.toggleNextButton(state)
            }).disposed(by: disposeBag)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind(onNext: { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeght(height)
            }).disposed(by: disposeBag)
        
        output.preventSpacing
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setAttribute()  { view.backgroundColor = .white }
    
    private func addSubComponents() {
        [navigationBar, progressBar, titleLabel, descriptionLabel, nicknameLabel, nicknameTextField, nextButton].forEach { view.addSubview($0) }
    }
    
    private func setConfiguration() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomNavigationBarNameSpace.navigationBarHeight)
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
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(NicknameNameSpace.baseLeadingInset)
            $0.trailing.equalToSuperview().inset(NicknameNameSpace.baseTrailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(NicknameNameSpace.nextButtonHeight)
        }
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
            NicknameViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
