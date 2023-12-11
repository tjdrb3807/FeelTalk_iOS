//
//  InviteCodeBottomSheetViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InviteCodeBottomSheetViewController: UIViewController {
    var viewModel: InviteCodeBottomSheetViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    // - dimmedView
    // - bottomSheetView
    //   - grabber
    //   - titleLabel
    //   - textField
    //   - connectionButton
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(InviteCodeBottomSheetNameSpace.dimmedViewBackgroundUpdateAlpha)
        
        return view
    }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = InviteCodeBottomSheetNameSpace.bottomSheetViewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var gradder: UIView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(named: InviteCodeBottomSheetNameSpace.gradderBackgroundColor)
        view.layer.cornerRadius = InviteCodeBottomSheetNameSpace.gradderCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = InviteCodeBottomSheetNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: InviteCodeBottomSheetNameSpace.titleLabelTextFont,
                            size: InviteCodeBottomSheetNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var inviteCodeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = InviteCodeBottomSheetNameSpace.textFieldPlaceholerText
        textField.backgroundColor = UIColor(named: InviteCodeBottomSheetNameSpace.textFieldBackgroundColor)
        textField.layer.cornerRadius = InviteCodeBottomSheetNameSpace.textFieldCornerRadius
        textField.clipsToBounds = true
        
        let paddingView = UIView(frame: CGRect(origin: .zero,
                                               size: CGSize(width: InviteCodeBottomSheetNameSpace.textFieldLeftPadding,
                                                            height: InviteCodeBottomSheetNameSpace.textFieldHeight)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var connectionButton: UIButton = {
        let button = UIButton()
        button.setTitle(InviteCodeBottomSheetNameSpace.connectionButtonTitleText, for: .normal)
        button.titleLabel?.font = UIFont(name: InviteCodeBottomSheetNameSpace.connectionButtonTitleTextFont,
                                         size: InviteCodeBottomSheetNameSpace.connectionButtonTitelTextSize)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: InviteCodeBottomSheetNameSpace.connectionButtonDisableBackgroundColor)
        button.layer.cornerRadius = InviteCodeBottomSheetNameSpace.connectionButtonCornerRadius
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
        self.bind(to: viewModel)
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
    }
    
    // MARK: MVVM
    private func bind(to viewModel: InviteCodeBottomSheetViewModel) {
        let input = InviteCodeBottomSheetViewModel.Input(inputInviteCode: inviteCodeTextField.rx.text.orEmpty,
                                               tapConnectionButton: connectionButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind(onNext: { vc, keyboardHeight in
                let height: CGFloat = keyboardHeight > InviteCodeBottomSheetNameSpace.keyboardDefaultHeight
                ? -keyboardHeight + vc.view.safeAreaInsets.bottom
                : InviteCodeBottomSheetNameSpace.keyboardDefaultHeight
                vc.updateKeyboard(height)
            }).disposed(by: disposeBag)
        
        output.connectionButtonEnabled
            .withUnretained(self)
            .bind(onNext: { vc, state in
                vc.toggleConnectionButton(state: state)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Default ui setting method
    private func setAttribute() {
        view.backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addBottomSheetViewSubComponenets()
        addViewControllerSubComponents()
    }
    
    private func setConfiguration() {
        makeDimmedViewConstraints()
        makeGradderConstraints()
        makeTitleLabelConstraints()
        makeTextFieldConstraints()
        makeConnectionButtonConstraints()
        makeBottomSheetViewConstraints()
    }
    
    private func showBottomSheet() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.bottomSheetViewUpdateHeight)
        }
        
        UIView.animate(withDuration: InviteCodeBottomSheetNameSpace.animateDuration,
                       delay: InviteCodeBottomSheetNameSpace.animateDelay,
                       options: .curveEaseIn,
                       animations: {
            self.dimmedView.alpha = InviteCodeBottomSheetNameSpace.dimmedViewBackgroundUpdateAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.bottomSheetViewDefaultHeight)
        }
        
        UIView.animate(withDuration: InviteCodeBottomSheetNameSpace.animateDelay,
                       delay: InviteCodeBottomSheetNameSpace.animateDelay,
                       options: .curveEaseIn, animations: {
            self.dimmedView.alpha = InviteCodeBottomSheetNameSpace.dimmedViewBackgroundDefaultAlpha
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}

// MARK: Subcomponents setting method
extension InviteCodeBottomSheetViewController {
    private func addViewControllerSubComponents() {
        [dimmedView, bottomSheetView].forEach { view.addSubview($0) }
    }
    
    private func addBottomSheetViewSubComponenets() {
        [gradder, titleLabel, inviteCodeTextField, connectionButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    private func makeDimmedViewConstraints() {
        dimmedView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.bottomSheetViewDefaultHeight)
        }
    }
    
    private func makeGradderConstraints() {
        gradder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(InviteCodeBottomSheetNameSpace.gradderTopInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(InviteCodeBottomSheetNameSpace.gradderWidth)
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.gradderHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gradder.snp.bottom).offset(InviteCodeBottomSheetNameSpace.titleLabelTopOffest)
            $0.leading.equalToSuperview().inset(InviteCodeBottomSheetNameSpace.baseSidesInset)
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.titlsLabelHeight)
        }
    }
    
    private func makeTextFieldConstraints() {
        inviteCodeTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(InviteCodeBottomSheetNameSpace.textFieldTopOffest)
            $0.leading.trailing.equalToSuperview().inset(InviteCodeBottomSheetNameSpace.baseSidesInset)
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.textFieldHeight)
        }
    }
    
    private func makeConnectionButtonConstraints() {
        connectionButton.snp.makeConstraints {
            $0.top.equalTo(inviteCodeTextField.snp.bottom).offset(InviteCodeBottomSheetNameSpace.connectionButtonTopOffset)
            $0.leading.trailing.equalToSuperview().inset(InviteCodeBottomSheetNameSpace.baseSidesInset)
            $0.height.equalTo(InviteCodeBottomSheetNameSpace.connectionButtonHeight)
        }
    }
}

// MARK: UI update method
extension InviteCodeBottomSheetViewController {
    private func updateKeyboard(_ keyboardHegiht: CGFloat) {
        bottomSheetView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(-keyboardHegiht)
        }
        
        view.layoutIfNeeded()
    }
    
    private func toggleConnectionButton(state: Bool) {
        state ?
        connectionButton.rx.backgroundColor.onNext(UIColor(named: InviteCodeBottomSheetNameSpace.connectionButtonEnableBackgroundColor)) :
        connectionButton.rx.backgroundColor.onNext(UIColor(named: InviteCodeBottomSheetNameSpace.connectionButtonDisableBackgroundColor))
        
        connectionButton.rx.isEnabled.onNext(state)
    }
}


#if DEBUG

import SwiftUI

struct InviteCodeBottomSheetViewController_Previews: PreviewProvider {
    static var previews: some View {
        InvteCodeBottomSheetViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct InvteCodeBottomSheetViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            InviteCodeBottomSheetViewController()
                
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
