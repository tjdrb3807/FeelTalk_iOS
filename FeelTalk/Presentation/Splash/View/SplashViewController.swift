//
//  SplashViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class SplashViewController: UIViewController {
    var viewModel: SplashViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_feeltalk_white")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘도 연인에 대해 더 알아가봐요!"
        label.textColor = UIColor(named: CommonColorNameSpace.main400)
        label.font = UIFont(name: CommonFontNameSpace.payboocMedium,
                            size: 14.0)
        label.setLineHeight(height: 17.28)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: SplashViewModel) {
        let input = SplashViewModel.Input(viewWillAppear: rx.viewWillAppear)
        
        let _ = viewModel.transfer(input: input)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeLogoImageViewConstraints()
        makeDescriptionLabelConstraints()
    }
}

extension SplashViewController {
    private func addViewSubComponents() {
        [logoImageView, descriptionLabel].forEach { view.addSubview($0) }
    }
    
    private func makeLogoImageViewConstraints() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(316.79)
            $0.width.equalTo(184)
            $0.height.equalTo(65)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(24.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct SplashViewController_Previews: PreviewProvider {
    static var previews: some View {
        SplashViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct SplashViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = SplashViewController()
            let vm = SplashViewModel(coordinator: DefaultSplashCoordinator(UINavigationController()),
                                     userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
