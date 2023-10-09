//
//  ChallengeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeViewController: UIViewController {
    var viewModel: ChallengeViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: MainFlowNavigationBar = { MainFlowNavigationBar(navigationType: .challenge) }()
    private lazy var collectionView: ChallengeCollectionView = { ChallengeCollectionView() }()
    
    private lazy var registerButton: ChallengeRegisterButton = { ChallengeRegisterButton() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
        self.bind(to: viewModel)
    }
    
    private func bind(to viewModel: ChallengeViewModel) {
        let input = ChallengeViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                             tapRegisterButton: registerButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.challengeCount
            .withUnretained(self)
            .bind { vc, count in
//                vc.collectionView.challengeTotalCount.accept(count.totalCount)
                print(count)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        view.backgroundColor = UIColor(named: "gray_100")
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeCollectionViewConstarint()
        makeRegisterButtonConstraints()
    }
}

extension ChallengeViewController {
    private func addViewSubComponents() {
        [navigationBar, collectionView, registerButton].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(MainFlowNavigationBarNameSpace.baseHeight)
        }
    }
    
    private func makeCollectionViewConstarint() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeRegisterButtonConstraints() {
        registerButton.snp.makeConstraints {
            $0.top.equalTo(registerButton.snp.bottom).offset(-51)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-71)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChallengeViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = ChallengeViewController()
            let vm = ChallengeViewModel(coordinator: DefaultChallengeCoordinator(UINavigationController()),
                                        challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
