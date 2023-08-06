//
//  AnswerViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AnswerViewController: UIViewController {
    // MARK: Dependencies
    var viewModel: AnswerViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(AnswerViewControllerNameSpace.dimmedViewAlpha)
        
        return view
    }()
    
    private lazy var chatRoomButton: ChatRoomButton = { ChatRoomButton() }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = AnswerViewControllerNameSpace.bottomSheetViewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var popButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AnswerViewControllerNameSpace.popButtonImage),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = AnswerViewControllerNameSpace.stackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true

        return stackView
    }()
    
    private lazy var questionTitleView: QuestionTitleView = { QuestionTitleView() }()
    private lazy var myAnswerView: MyAnswerView = { MyAnswerView() }()
    private lazy var partnerAnswerView: PartnerAnswerView = { PartnerAnswerView() }()
    
    private lazy var answerCompletedButton: UIButton = {
        let button = UIButton()
        button.setTitle(AnswerViewControllerNameSpace.answerCompletedButtonTitleText,
                        for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: AnswerViewControllerNameSpace.answerCompletedButtonTitleTextFont,
                                         size: AnswerViewControllerNameSpace.answerCompletedButtonTitleTextSize)
        button.backgroundColor = UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonDeactivationBackgroundColor)
        button.layer.cornerRadius = AnswerViewControllerNameSpace.answerCompletedButtonBaseCornerRadius
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: ViewController life cycle method.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttribute()
        self.addSubComponents()
        self.setConfigurations()
        self.bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
    }
    
    // MARK: ViewController base setting method.
    private func bind(to viewModel: AnswerViewModel) {
        let input = AnswerViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            inputAnswer: myAnswerView.answerTextView.rx.text.orEmpty,
            tapAnswerCompletedButton: answerCompletedButton.rx.tap,
            tapPopButton: popButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeight(height)
            }.disposed(by: disposeBag)
        
        output.isActiveAnswerCompletedButton
            .withUnretained(self)
            .bind { vc, state in
                vc.switchActiveAnswerCompletedButton(state)
            }.disposed(by: disposeBag)
        
        output.question
            .withUnretained(self)
            .bind { vc, model in
                print(model)
                vc.setData(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        view.backgroundColor = .clear
        hideKeyboardWhenTappedAround()
    }
    
    private func addSubComponents() {
        addViewControllerSubComponents()
        addBottomSheetViewSubComponents()
        addScrollViewSubComponents()
        addStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeDimmedViewConstraints()
        makeChatRoomButtonConstraints()
        makeBottomSheetViewConstraints()
        makePopButtonConstraints()
        makeScrollViewConstraints()
        makeStackViewConstraints()
        makeQuestionTitleViewConstraints()
        makeMyAnswerViewConstraints()
        makePartnerAnswerViewConstraints()
        makeAnswerCompletedButtonConstraints()
    }
}

// MARK: UI setting method.
extension AnswerViewController {
    private func addViewControllerSubComponents() {
        [dimmedView, chatRoomButton, bottomSheetView].forEach { view.addSubview($0) }
    }
    
    private func makeDimmedViewConstraints() {
        dimmedView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeChatRoomButtonConstraints() {
        chatRoomButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChatRoomButtonNameSpace.topInset)
            $0.leading.equalTo(chatRoomButton.snp.trailing).offset(ChatRoomButtonNameSpace.leadingOffset)
            $0.trailing.equalToSuperview().inset(ChatRoomButtonNameSpace.trailingInset)
            $0.bottom.equalTo(chatRoomButton.snp.top).offset(ChatRoomButtonNameSpace.height)
        }
    }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(AnswerViewControllerNameSpace.bottomSheetViewBaseHeight)
        }
    }
    
    private func addBottomSheetViewSubComponents() {
        [popButton, scrollView, answerCompletedButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    private func makePopButtonConstraints() {
        popButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AnswerViewControllerNameSpace.popButtonTopInset)
            $0.leading.equalToSuperview().inset(AnswerViewControllerNameSpace.popButtonLeadingInset)
            $0.width.height.equalTo(AnswerViewControllerNameSpace.popButtonWidth)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(AnswerViewControllerNameSpace.scrollViewSideInset)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(AnswerViewControllerNameSpace.scrollViewHeight)
        }
    }
    
    private func addScrollViewSubComponents() {
        [stackView].forEach { scrollView.addSubview($0) }
    }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func addStackViewSubComponents() {
        [questionTitleView, myAnswerView, partnerAnswerView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func makeQuestionTitleViewConstraints() {
        questionTitleView.snp.makeConstraints { $0.height.equalTo(QuestionTitleViewNameSpace.height) }
    }
    
    private func makeMyAnswerViewConstraints() {
        myAnswerView.snp.makeConstraints { $0.height.equalTo(MyAnswerViewNameSpace.height) }
    }
    
    private func makePartnerAnswerViewConstraints() {
        partnerAnswerView.snp.makeConstraints { $0.height.equalTo(PartnerAnswerViewNameSpace.noAnswerTypeHeight)}
    }
    
    private func makeAnswerCompletedButtonConstraints() {
        answerCompletedButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(AnswerViewControllerNameSpace.answerCompletedButtonBaseSideInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(AnswerViewControllerNameSpace.answerCompletedButtonHeight)
        }
    }
}

// MARK: Animation method
extension AnswerViewController {
    private func showBottomSheet() {
        bottomSheetView.snp.updateConstraints { $0.height.equalTo(AnswerViewControllerNameSpace.bottomSheetViewUpdateHeight) }
        
        UIView.animate(withDuration: AnswerViewControllerNameSpace.dimmedViewAnimateDuration,
                       delay: AnswerViewControllerNameSpace.dimmedViewAnimateDelay,
                       options: .overrideInheritedDuration , animations: {
            self.dimmedView.alpha = AnswerViewControllerNameSpace.dimmedViewAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: Update method.
extension AnswerViewController {
    private func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        if keyboardHeight == 0.0 {
            answerCompletedButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight)
                $0.leading.trailing.equalToSuperview().inset(AnswerViewControllerNameSpace.answerCompletedButtonBaseSideInset)
            }
            answerCompletedButton.layer.rx.cornerRadius.onNext(AnswerViewControllerNameSpace.answerCompletedButtonBaseCornerRadius)
        } else {
            answerCompletedButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight)
                $0.leading.trailing.equalToSuperview()
            }
            answerCompletedButton.layer.rx.cornerRadius.onNext(AnswerViewControllerNameSpace.answerCompletedButtonUpdateCornerRadius)
        }
        
        view.layoutIfNeeded()
    }
    
    private func switchActiveAnswerCompletedButton(_ state: Bool) {
        if state {
            answerCompletedButton.rx.backgroundColor
                .onNext(UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonActivationBackgroundColor))
        } else {
            answerCompletedButton.rx.backgroundColor
                .onNext(UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonDeactivationBackgroundColor))
        }
        answerCompletedButton.rx.isEnabled.onNext(state)
    }
    
    private func setData(with model: Question) {
        self.questionTitleView.setDate(title: model.title,
                                       header: model.header,
                                       body: model.body,
                                       highlight: model.highlight)
        self.myAnswerView.setData(with: model)
        self.partnerAnswerView.setData(with: model)
        self.updateAnswerCompletedButton(isMyAnswer: model.isMyAnswer, isPartnerAnswer: model.isPartnerAnswer)
    }
    
    private func updateAnswerCompletedButton(isMyAnswer: Bool, isPartnerAnswer: Bool) {
        if isMyAnswer && isPartnerAnswer { // 둘 다 답변한 경우
            answerCompletedButton.rx.title().onNext(AnswerViewControllerNameSpace.answerCompletedButtonUpdateTitleText)
            answerCompletedButton.rx.backgroundColor.onNext(UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonActivationBackgroundColor))
            answerCompletedButton.rx.isHidden.onNext(false)
            answerCompletedButton.rx.isEnabled.onNext(true)
        } else if isMyAnswer && !isPartnerAnswer {  // 나만 답변한 경우
            answerCompletedButton.rx.isHidden.onNext(true)
        } else if !isMyAnswer && isPartnerAnswer {  // 상대만 답변한 경우
            answerCompletedButton.rx.title().onNext(AnswerViewControllerNameSpace.answerCompletedButtonTitleText)
            answerCompletedButton.rx.backgroundColor.onNext(UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonDeactivationBackgroundColor))
            answerCompletedButton.rx.isHidden.onNext(false)
            answerCompletedButton.rx.isEnabled.onNext(false)
        } else { // 둘 다 답변하지 않은 경우
            answerCompletedButton.rx.title().onNext(AnswerViewControllerNameSpace.answerCompletedButtonTitleText)
            answerCompletedButton.rx.backgroundColor.onNext(UIColor(named: AnswerViewControllerNameSpace.answerCompletedButtonDeactivationBackgroundColor))
            answerCompletedButton.rx.isHidden.onNext(false)
            answerCompletedButton.rx.isEnabled.onNext(false)
        }
    }
}

#if DEBUG

import SwiftUI

struct AnswerViewController_Previews: PreviewProvider {
    static var previews: some View {
        AnswerViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct AnswerViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            AnswerViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
