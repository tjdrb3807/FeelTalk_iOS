//
//  QuestionViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionViewController: UIViewController {
    // MARK: Dependencies
    private var viewModel: QuestionViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    private lazy var navigationBar: MainFlowNavigationBar = { MainFlowNavigationBar(navigationType: .question) }()
    private lazy var questionTableView: QuestionTableView = { QuestionTableView() }()
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.bind(to: viewModel)
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    // MARK: ViewController setting method
    private func bind(to viewModel: QuestionViewModel) {
        
    }
    
    private func setAttributes() {
        view.backgroundColor = UIColor(named: "gray_100")
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubComponents() {
        [navigationBar, questionTableView].forEach { view.addSubview($0) }
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeQuestionTableViewConstraints()
    }
}

// MARK: DI method
extension QuestionViewController {
    final class func create(with ViewModel: QuestionViewModel) -> QuestionViewController {
        let viewController = QuestionViewController()
        viewController.viewModel = ViewModel
        
        return viewController
    }
}

// MARK: UI setting method
extension QuestionViewController {
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MainFlowNavigationBarNameSpace.navigationBarHeight)
        }
    }
    
    private func makeQuestionTableViewConstraints() {
        questionTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(QuestionTableHeaderViewNameSpace.topOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewController_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct QuestionViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            QuestionViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
