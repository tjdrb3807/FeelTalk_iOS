//
//  NewsAgencyViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NewsAgencyViewController: BottomSheetViewController {
    var viewModel: NewsAgencyViewModel!
    private let selectedNewsAgency = PublishSubject<NewsAgencyType>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NewsAgecnyViewControllerNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: NewsAgecnyViewControllerNameSpace.titleLabelTextSize)
        label.setLineHeight(height: NewsAgecnyViewControllerNameSpace.titleLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = NewsAgecnyViewControllerNameSpace.buttonStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: NewsAgencyViewModel) {
        let input = NewsAgencyViewModel.Input(tapNewsAgnecyButton: selectedNewsAgency,
                                              dismiss: super.dismiss)
        
        let _ = viewModel.transfer(input: input)
    }
    
    private func setProperties() {
        setTopInset(NewsAgecnyViewControllerNameSpace.bottomSheetViewTopInset)
        configNewsAgencyButton()
    }
    
    private func addSubComponents() {
        addBottomSheetViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeButtonStackViewConstraints()
    }
}

extension NewsAgencyViewController {
    private func addBottomSheetViewSubComponents() {
        [titleLabel, buttonStackView].forEach { super.bottomSheetView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(NewsAgecnyViewControllerNameSpace.titleLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeButtonStackViewConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(NewsAgecnyViewControllerNameSpace.buttonStackViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func configNewsAgencyButton() {
        NewsAgencyType.allCases
            .forEach { type in
                let newsAgencyButton = NewsAgencyButton(type: type)
                
                buttonStackView.addArrangedSubview(newsAgencyButton)
                
                newsAgencyButton.snp.makeConstraints { $0.height.equalTo(NewsAgencyButtonNameSpace.height) }
                
                newsAgencyButton.rx.tap
                    .map { _ in type }
                    .withUnretained(self)
                    .bind { vc, type in
                        newsAgencyButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray100))
                        vc.selectedNewsAgency.onNext(type)
                        vc.hide()
                    }.disposed(by: disposeBag)
            }
    }

}

#if DEBUG

import SwiftUI

struct NewsAgencyViewController_Previews: PreviewProvider {
    static var previews: some View {
        NewsAgencyViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct NewsAgencyViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let v = NewsAgencyViewController()
            let vm = NewsAgencyViewModel(coordinator: DefaultNewsAgencyCoordinator(UINavigationController()))
            
            v.viewModel = vm
            
            return v
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
