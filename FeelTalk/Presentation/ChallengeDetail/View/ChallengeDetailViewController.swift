//
//  ChallengeDetailViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class ChallengeDetailViewController: UIViewController {
    var viewModel: ChallengeDetailViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: ChallengeDetailNavigationBar = { ChallengeDetailNavigationBar() }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .black
        scrollView.setTapGesture()
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDetailViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var descriptionView: ChallengeDetailDescriptionView = { ChallengeDetailDescriptionView() }()
    
    private lazy var titleInputView: ChallengeTitleView = { ChallengeTitleView() }()
    
    private lazy var deadlineInputView: ChallengeDeadlineView = { ChallengeDeadlineView() }()
    
    private lazy var contentInputView: ChallengeContentView = { ChallengeContentView() }()
    
    private lazy var challengeButton: ChallengeButton = { ChallengeButton() }()
    
    private lazy var alertView: CustomAlertView = { CustomAlertView(type: .challengeAddCancel) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bind()
        self.bind(to: viewModel)
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bind() {
        
    }
    
    private func bind(to viewModel: ChallengeDetailViewModel) {
        let alertRightButtonTapObserver = PublishRelay<CustomAlertType>()
        
        let input = ChallengeDetailViewModel.Input(viewWillAppear: rx.viewWillAppear,
                                                   tapNavigationButton: navigationBar.tapButtonObserver.asObservable(),
                                                   titleObserver: titleInputView.titleInputView.rx.text.orEmpty,
                                                   deadlineObserver: deadlineInputView.deadlineObserver,
                                                   contentObserver: contentInputView.contentInputView.textView.rx.text.orEmpty,
                                                   alertRightButtonTapObserver: alertRightButtonTapObserver.asObservable(),
                                                   challengeButtonTapObserver: challengeButton.rx.tap.asObservable())
        
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .skip(1)
            .withUnretained(self)
            .bind { vc, event in
                let height = event > 0.0 ? -event + vc.view.safeAreaInsets.bottom : 0
                vc.updateScrollViewConstraints(with: height)
            }.disposed(by: disposeBag)
        
        output.type
            .withUnretained(self)
            .bind { vc, event in
                vc.navigationBar.typeObserver.accept(event)
                vc.descriptionView.typeObserver.accept(event)
                vc.titleInputView.typeObserver.accept(event)
                vc.deadlineInputView.typeObserver.accept(event)
                vc.contentInputView.typeObserver.accept(event)
                vc.challengeButton.typeObserver.accept(event)
            }.disposed(by: disposeBag)
        
        output.popUpAlerObserver
            .withUnretained(self)
            .bind { vc, type in
                guard !vc.view.subviews.contains(where: { $0 is CustomAlertView }) else { return }
                let alertView = CustomAlertView(type: type)
                
                alertView.rightButton.rx.tap
                    .map { type }
                    .bind { type in
                        alertRightButtonTapObserver.accept(type)
                        alertView.hide()
                    }.disposed(by: vc.disposeBag)
                
                vc.view.addSubview(alertView)
                alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                
                alertView.show()
            }.disposed(by: disposeBag)
        
        output.isNewTypeChallengeButtonEnabled
            .withUnretained(self)
            .bind { vc, state in
                vc.challengeButton.rx.isEnabled.onNext(state)
                
                state ?
                vc.challengeButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
                vc.challengeButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
            }.disposed(by: disposeBag)

        Observable
            .merge(titleInputView.toolBarButtonTapObserver.asObservable(),
                   deadlineInputView.toolBarButtonTapObserver.asObservable(),
                   contentInputView.toolBarButtonTapObserver.asObservable())
            .withUnretained(self)
            .bind { vc, type in
                DispatchQueue.main.async {
                    switch type {
                    case .title:
                        vc.deadlineInputView.deadlineInputView.becomeFirstResponder()
                    case .deadline:
                        vc.contentInputView.contentInputView.textView.becomeFirstResponder()
                    case .content:
                        break
                    }
                }
            }.disposed(by: disposeBag)

        Observable<ChallengeDetailViewInputType>
            .merge(titleInputView.titleInputView.rx.controlEvent(.editingDidBegin).map { .title },
                   deadlineInputView.deadlineInputView.rx.controlEvent(.editingDidBegin).map { .deadline },
                   contentInputView.contentInputView.textView.rx.didBeginEditing .map { .content })
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .title:
                    vc.scrollView.scrollToTop()
                case .deadline:
                    print(type)
                case .content:
                    vc.scrollView.scrollToBottom()
                }
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeScrollViewConstraints()
        makeContentStackViewSubComponents()
        makeDescriptionViewConstraints()
        makeTitleInputViewConstraints()
        makeDeadlineInputViewConstraints()
        makeContentInputViewConstraints()
        makeChallengeButtonConstraints()
    }
}

extension ChallengeDetailViewController {
    private func addViewSubComponents() {
        [navigationBar, scrollView, challengeButton].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(ChallengeDetailNavigationBarNameSpace.height)
        }
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.backgroundColor = .blue.withAlphaComponent(0.4)
    }
    
    private func addScrollViewSubComponents() {
        scrollView.addSubview(contentStackView)
    }
    
    private func makeContentStackViewSubComponents() {
        contentStackView.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [descriptionView, titleInputView, deadlineInputView, contentInputView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionViewConstraints() {
        descriptionView.snp.makeConstraints { $0.height.equalTo(ChallengeDetailDescriptionViewNameSpace.height) }
    }
    
    private func makeTitleInputViewConstraints() {
        titleInputView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    private func makeDeadlineInputViewConstraints() {
        deadlineInputView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    private func makeContentInputViewConstraints() {
        contentInputView.snp.makeConstraints { $0.width.equalToSuperview() }
    }

    private func setStackViewSubComponentsConstraints() {
        [titleInputView, deadlineInputView, contentInputView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
        }
    }
    
    private func makeChallengeButtonConstraints() {
        challengeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(ChallengeButtonNameSpace.height)
        }
    }
}

extension ChallengeDetailViewController {
    private func updateScrollViewConstraints(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(keyboardHeight) }
        
        view.layoutIfNeeded()
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChallengeDetailViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = ChallengeDetailViewController()
            let vm = ChallengeDetailViewModel(coordinator: DefaultChallengeDetailCoordinator(UINavigationController()),
                                              challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
            vm.typeObserver.accept(.new)
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
