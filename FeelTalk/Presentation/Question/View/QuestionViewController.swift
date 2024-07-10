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
    var viewModel: QuestionViewModel!
    private let disposeBag = DisposeBag()
    private var lastContentOffset: CGFloat = 0.0
    
    private lazy var navigationBar: MainNavigationBar = { MainNavigationBar(type: .question) }()
    
    private lazy var questionTableView: QuestionTableView = { QuestionTableView() }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
        
        // MARK: Mixpanel
        MixpanelRepository.shared.navigatePage()
        MixpanelRepository.shared.setInQuestionPage(isInQuestion: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // MARK: Mixpanel
        MixpanelRepository.shared.setInQuestionPage(isInQuestion: false)
    }
    
    private func bind(to viewModel: QuestionViewModel) {
        let input = QuestionViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
         tapQuestionAnswerButton: questionTableView
            .questionTableHeader
            .questionAnswerButton.rx.tap
            .withLatestFrom(questionTableView.questionTableHeader.model),
         questionSelected: questionTableView.rx.modelSelected(Question.self).asObservable(),
         isPagination: questionTableView.rx.didScroll
            .withUnretained(self)
            .map { vm, _ in
                let contentOffsetY = vm.questionTableView.contentOffset.y
                let contentSizeHeight = vm.questionTableView.contentSize.height
                let paginationY = contentOffsetY * 0.2  // TODO: page 30개로 늘리면 변경
                
                return contentOffsetY > contentSizeHeight - paginationY ? true : false
            },
            tapChatRoomButton: navigationBar.chatRoomButton.rx.tap
        )
        
        let output = viewModel.transfer(input: input)
        
        output.todayQuestion
            .withUnretained(self)
            .bind { vc, todayQuestion in
                vc.questionTableView.questionTableHeader.model.accept(todayQuestion)
                
            }.disposed(by: disposeBag)
        
        output.questionList
            .asDriver(onErrorJustReturn: [])
            .drive(questionTableView.rx.items) { [weak self] tv, row, model in
                guard let self = self else { return UITableViewCell() }
                let index = IndexPath(row: row, section: 0)
                let cell = self.questionTableView.dequeueReusableCell(withIdentifier: QuestionTableViewCellNameSpace.identifier,
                                                                 for: index) as! QuestionTableViewCell
                
                cell.model.accept(model)
                cell.selectionStyle = .none
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        view.backgroundColor = UIColor(named: "gray_100")
        navigationController?.navigationBar.isHidden = true
        self.setupNavigationBarHidden()
    }
    
    private func addSubComponents() {
        [questionTableView, navigationBar].forEach { view.addSubview($0) }
    }
    
    private func setConfigurations() {
        navigationBar.makeMainNavigationBarConstraints()
        makeQuestionTableViewConstraints()
    }
}

extension QuestionViewController {
    private func makeQuestionTableViewConstraints() {
        questionTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension QuestionViewController {
    private func setupNavigationBarHidden() {
        questionTableView.rx.contentOffset
            .map { $0.y }
            .withUnretained(self)
            .bind { vc, offsetY in
                if offsetY > vc.lastContentOffset && offsetY > 0.0 {
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                        vc.navigationBar.rx.isHidden.onNext(true)
                    })
                } else if offsetY < vc.lastContentOffset {
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                        vc.navigationBar.rx.isHidden.onNext(false)
                    })
                }
                
                vc.lastContentOffset = offsetY
            }.disposed(by: disposeBag)
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
            let vc = QuestionViewController()
            vc.viewModel = QuestionViewModel(coordiantor: DefaultQuestionCoordinator(UINavigationController()),
                                             questionUseCase: DefaultQuestionUseCase(questionRepository: DefaultQuestionRepository(),
                                                                                     userRepository: DefaultUserRepository()))
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
