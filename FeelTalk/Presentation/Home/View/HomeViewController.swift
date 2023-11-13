//
//  HomeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: HomeNavigationBar = { HomeNavigationBar() }()
    
    fileprivate lazy var todayQuestionView: HomeTodayQuestionView = { HomeTodayQuestionView() }()
    
    fileprivate lazy var todaySignalView: HomeTodaySignalView = { HomeTodaySignalView() }()
    
    fileprivate lazy var toastMessage: ToastMessage = { ToastMessage(type: .requestAnswer) }()
    
    fileprivate lazy var bottomSheet: HomeBottomSheetView = { HomeBottomSheetView() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: HomeViewModel) {
        let input = HomeViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                        tapAnswerButton: todayQuestionView.answerButton.rx.tap,
                                        tapMySignalButton: todaySignalView.mySignalButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.todayQuestion
            .bind(to: todayQuestionView.todayQuestion)
            .disposed(by: disposeBag)
        
        output.partenrSignalModel
            .bind(to: todaySignalView.partnerSignalButton.model)
            .disposed(by: disposeBag)
        
        output.mySignalModel
            .bind(to: todaySignalView.mySignalButton.model)
            .disposed(by: disposeBag)
            
        output.popUpToastMessage
            .withUnretained(self)
            .bind { vc, _ in
                guard !vc.view.subviews.contains(where: { $0 is ToastMessage }) else { return }
                let toastMessage = vc.toastMessage
                vc.view.addSubview(toastMessage)
                toastMessage.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                toastMessage.show()
            }.disposed(by: disposeBag)
        
        output.showBottomSheet
            .withUnretained(self)
            .bind { vc, _ in
                guard !vc.view.subviews.contains(where: { $0 is HomeBottomSheetView }) else { return }
                let bottomSheet = vc.bottomSheet
                vc.view.addSubview(bottomSheet)
                bottomSheet.snp.makeConstraints { $0.edges.equalToSuperview() }
                vc.view.layoutIfNeeded()
                bottomSheet.isHidden(false)
            }.disposed(by: disposeBag)
        
        bottomSheet.confirmButton.rx.tap
            .delay(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationController?.tabBarController?.tabBar.rx.isHidden.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
        makeTodayQuestionViewConstraints()
        makeTodaySignalViewConstraints()
    }
}

extension HomeViewController {
    private func addViewSubComponents() {
        [navigationBar, todayQuestionView, todaySignalView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(HomeNavigationBarNameSpace.height)
        }
    }
    
    private func makeTodayQuestionViewConstraints() {
        todayQuestionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(HomeTodayQuestionViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(HomeTodayQuestionViewNameSpace.height)
        }
    }
    
    private func makeTodaySignalViewConstraints() {
        todaySignalView.snp.makeConstraints {
            $0.top.equalTo(todayQuestionView.snp.bottom).offset(HomeTodaySignalViewNameSpace.topOffset)
            $0.left.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(HomeTodaySignalViewNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct HomeViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = HomeViewController()
            let vm = HomeViewModel(coordinator: DefaultHomeCoordinator(UINavigationController()),
                                   qustionUseCase: DefaultQuestionUseCase(
                                    questionRepository: DefaultQuestionRepository()))
            
            vc.todayQuestionView.todayQuestion.accept(.init(index: 999,
                                                            pageNo: 0,
                                                            title: "",
                                                            header: "",
                                                            body: "",
                                                            highlight: [0],
                                                            isMyAnswer: true,
                                                            isPartnerAnswer: false,
                                                            createAt: "2023-02-33"))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
