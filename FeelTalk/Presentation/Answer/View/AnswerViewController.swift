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
    var viewModel: AnswerViewModel!
    private let disposeBag = DisposeBag()

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(AnswerViewControllerNameSpace.dimmedViewAlpha)
        
        return view
    }()
    
    private lazy var chatRoomButton: CustomChatRoomButton = { CustomChatRoomButton() }()
    
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
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    private lazy var answerCompletedButton: UIButton = {
        let button = UIButton()
        button.setTitle(AnswerViewControllerNameSpace.answerCompletedButtonTitleText,
                        for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: AnswerViewControllerNameSpace.answerCompletedButtonTitleTextSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main400)
        button.layer.cornerRadius = AnswerViewControllerNameSpace.answerCompletedButtonBaseCornerRadius
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var popUpAlert: CustomAlertView = { CustomAlertView(type: .popAnswer) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConfigurations()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
        MixpanelRepository.shared.setInAnswerSheet(isInAnswer: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.show()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.setInAnswerSheet(isInAnswer: false)
    }
    
    private func bind(to viewModel: AnswerViewModel) {
        let tapAlertRightButtonObserver = PublishSubject<CustomAlertType>()
        
        let input = AnswerViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            myAnswerObserver: myAnswerView.answerInputView.textView.rx.text.orEmpty,
            tapPressForAnswerButton: partnerAnswerView.noAnswerView.pressForAnswerButton.rx.tap,
            tapPopButton: popButton.rx.tap,
            tapAlertRightButton: tapAlertRightButtonObserver.asObserver(),
            tapAnswerCompletedButton: answerCompletedButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
            
        output.model
            .withUnretained(self)
            .bind { vc, model in
                vc.questionTitleView.model.accept(model)
                vc.myAnswerView.model.accept(model)
                vc.partnerAnswerView.model.accept(model)
                vc.setupAnswerCompletedButton(with: model)
            }.disposed(by: disposeBag)
        
        output.isActiveAnswerCompletedButton
            .withUnretained(self)
            .bind { vc, state in
                vc.updateAnswerCompletedButtonProperties(with: state)
            }.disposed(by: disposeBag)
        
        output.keyboardHeight
            .skip(1)
            .withUnretained(self)
            .bind { vc, keyboardHeight in
                let keyboardHeight = keyboardHeight > 0 ? keyboardHeight - vc.view.safeAreaInsets.bottom : 0
                vc.updateScrollViewConstraints(with: keyboardHeight)
                vc.updateAnswerCompletedButtonConstraints(with: keyboardHeight)
                vc.updateAnswerCompletedButtonCornerRadius(with: keyboardHeight)
            }.disposed(by: disposeBag)
        
        output.bottomSheetHiddenObserver
            .withUnretained(self)
            .bind { vc, _ in
                vc.hidden()
            }.disposed(by: disposeBag)
        
        output.popUpAlertObserver
            .withUnretained(self)
            .bind { vc, alertType in
                guard !vc.view.subviews.contains(where: { $0 is CustomAlertView }) else { return }
                let alertView = CustomAlertView(type: alertType)
                
                alertView.rightButton.rx.tap
                    .map { alertType }
                    .bind { type in
                        tapAlertRightButtonObserver.onNext(type)
                        alertView.hide()
                    }.disposed(by: vc.disposeBag)
                
                vc.view.addSubview(alertView)
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                
                alertView.show()
            }.disposed(by: disposeBag)
        
        output.popUpPressForAnswerToastMessage
            .withUnretained(self)
            .bind { vc, partnerName in
                guard !vc.view.subviews.contains(where: { $0 is CustomToastMessage}) else { return }
                let toastMessage = CustomToastMessage(message: "\(partnerName)님을 콕 찔렀어요!")
                
                vc.view.addSubview(toastMessage)
                toastMessage.setConstraints()
                vc.view.layoutIfNeeded()
                
                toastMessage.show()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .clear
        hideKeyboardWhenTappedAround()
        bottomSpacing.isHidden = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
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
        makeAnserCompletedButtonConstraints()
    }
}

extension AnswerViewController {
    private func addViewSubComponents() {
        [dimmedView, chatRoomButton, bottomSheetView].forEach { view.addSubview($0) }
    }
    
    private func makeDimmedViewConstraints() {
        dimmedView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeChatRoomButtonConstraints() {
        chatRoomButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CustomChatRoomButtonNameSpace.topOffset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.width.equalTo(CustomChatRoomButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(CustomChatRoomButtonNameSpace.profileImageViewHeight)
        }
    }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-UIScreen.main.bounds.height)
        }
    }
    
    private func addBottomSheetViewSubComponents() {
        [popButton, scrollView, answerCompletedButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    private func makePopButtonConstraints() {
        popButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AnswerViewControllerNameSpace.popButtonTopInset)
            $0.leading.equalToSuperview().inset(AnswerViewControllerNameSpace.popButtonLeadingInset)
            $0.width.equalTo(AnswerViewControllerNameSpace.popButtonWidth)
            $0.height.equalTo(AnswerViewControllerNameSpace.popButtonHeight)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AnswerViewControllerNameSpace.scrollViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + AnswerViewControllerNameSpace.answerCompletedButtonHeight)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(stackView) }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func addStackViewSubComponents() {
        [questionTitleView, myAnswerView, partnerAnswerView, bottomSpacing].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func makeQuestionTitleViewConstraints() {
        questionTitleView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(QuestionTitleViewNameSpace.height)
        }
    }
    
    private func makeAnserCompletedButtonConstraints() {
        answerCompletedButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalToSuperview().inset(Utils.safeAreaBottomInset())
            $0.height.equalTo(AnswerViewControllerNameSpace.answerCompletedButtonHeight)
        }
    }
}

extension AnswerViewController {
    private func show() {
        bottomSheetView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(AnswerViewControllerNameSpace.bottomSheetViewTopInset)
            $0.bottom.equalToSuperview()
        }

        UIView.animate(withDuration: AnswerViewControllerNameSpace.dimmedViewAnimateDuration,
                       delay: AnswerViewControllerNameSpace.dimmedViewAnimateDelay,
                       options: .curveEaseInOut,
                       animations: {
            self.dimmedView.alpha = AnswerViewControllerNameSpace.dimmedViewAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hidden() {
        bottomSheetView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.bottom.equalToSuperview().inset(-UIScreen.main.bounds.height)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
}

extension AnswerViewController {
    private func updateScrollViewConstraints(with keyboardHeight: CGFloat) {
        if keyboardHeight == 0.0 {
            scrollView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + AnswerViewControllerNameSpace.answerCompletedButtonHeight)
            }
            bottomSpacing.rx.isHidden.onNext(true)
        } else {
            scrollView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + AnswerViewControllerNameSpace.answerCompletedButtonHeight + view.safeAreaInsets.bottom)
            }
            bottomSpacing.rx.isHidden.onNext(false)
        }
        
        view.layoutIfNeeded()
    }
    
    private func updateAnswerCompletedButtonConstraints(with keyboardHeight: CGFloat) {
        if keyboardHeight == 0.0 {
            answerCompletedButton.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
                $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
                $0.bottom.equalToSuperview().inset(Utils.safeAreaBottomInset())
            }
        } else {
            answerCompletedButton.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardHeight + view.safeAreaInsets.bottom)
            }
        }

        view.layoutIfNeeded()
    }
    
    private func updateAnswerCompletedButtonCornerRadius(with keyboardHeight: CGFloat) {
        if keyboardHeight == 0.0 {
            answerCompletedButton.layer.rx.cornerRadius.onNext(AnswerViewControllerNameSpace.answerCompletedButtonBaseCornerRadius)
        } else {
            answerCompletedButton.layer.rx.cornerRadius.onNext(AnswerViewControllerNameSpace.answerCompletedButtonUpdateCornerRadius)
        }
    }
    
    private func setupAnswerCompletedButton(with model: Question) { answerCompletedButton.rx.isHidden.onNext(model.isMyAnswer) }
    
    private func updateAnswerCompletedButtonProperties(with state : Bool) {
        let backgroundColor = state ? UIColor(named: CommonColorNameSpace.main500) : UIColor(named: CommonColorNameSpace.main400)
        
        answerCompletedButton.rx.backgroundColor.onNext(backgroundColor)
        answerCompletedButton.rx.isEnabled.onNext(state)
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
            let vc = AnswerViewController()
            let vm = AnswerViewModel(coordinator: DefaultAnswerCoordinator(UINavigationController()),
                                     questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository(),
                                                                             userRepository: DefaultUserRepository()),
                                     userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
            vm.model.accept(.init(index: 0,
                                  pageNo: 0,
                                  title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
                                  header: "난 이게 가장 좋더라!",
                                  body: "당신이 가장 좋아하는 스킨십은?",
                                  highlight: [0],
                                  myAnser: "이력서를 작성할 때 글자수를 확인하기 위해 포털사이트에 내용을 복사 붙여 넣기를 하여 확인하곤 합니다. 또한 공모전에 응모한다면 200자 원고지 100매와 같은 기준에 맞추기 위",
                                  partnerAnser: "이력서를 작성할 때 글자수를 확인하기 위해 포털사이트에 내용을 복사 붙여 넣기를 하여 확인하곤 합니다. 또한 공모전에 응모한다면 200자 원고지 100매와 같은 기준에 맞추기 위",
                                  isMyAnswer: false,
                                  isPartnerAnswer: false,
                                  createAt: "hhh"))
            vc.viewModel = vm
            
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
