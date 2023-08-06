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
    var viewModel: QuestionViewModel!
    private let disposeBag = DisposeBag()

    // MARK: SubComponents
    private lazy var navigationBar: MainFlowNavigationBar = { MainFlowNavigationBar(navigationType: .question) }()
    private lazy var questionTableView: QuestionTableView = { QuestionTableView() }()
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
        self.bind(to: viewModel)
    }
    
    private func bind(to viewModel: QuestionViewModel) {
        let input = QuestionViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            tapQuestionAnswerButton: questionTableView.questionTableHeader.questionAnswerButton.rx.tap
                .withLatestFrom(questionTableView.questionTableHeader.model),
            questionSelected: questionTableView.rx.modelSelected(Question.self).asObservable(),
            prefetchRow: questionTableView.rx.prefetchRows.compactMap(\.last?.row),
            isPagination: questionTableView.rx.didScroll
                .withUnretained(self)
                .map { vm, _ in
                    let contentOffsetY = vm.questionTableView.contentOffset.y
                    let contentSizeHeight = vm.questionTableView.contentSize.height
                    let paginationY = contentOffsetY * 0.9  // TODO: page 30개로 늘리면 변경
                    
                    return contentOffsetY > contentSizeHeight - paginationY ? true : false
                }
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
                let cell = questionTableView.dequeueReusableCell(withIdentifier: QuestionTableViewCellNameSpace.identifier,
                                                                 for: index) as! QuestionTableViewCell
                
                cell.model.accept(model)
                cell.selectionStyle = .none

                return cell
            }.disposed(by: disposeBag)
    }
    
    // MARK: ViewController setting method
    private func setAttributes() {
        view.backgroundColor = UIColor(named: "gray_100")
        navigationController?.navigationBar.isHidden = true
        self.updateNavigationBarHeight()
    }
    
    private func addSubComponents() {
        [questionTableView, navigationBar].forEach { view.addSubview($0) }
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeQuestionTableViewConstraints()
    }
}

// MARK: UI setting method
extension QuestionViewController {
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MainFlowNavigationBarNameSpace.baseHeight)
        }
    }
    
    private func makeQuestionTableViewConstraints() {
        questionTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension QuestionViewController {
    private func updateNavigationBarHeight() {
        questionTableView.rx.willEndDragging
            .withUnretained(self)
            .bind { vc, event in
                UIView.animate(withDuration: MainFlowNavigationBarNameSpace.animateDuration) {
                    guard event.velocity.y != MainFlowNavigationBarNameSpace.scrollVelocityCriteria else { return }
                    if event.velocity.y < MainFlowNavigationBarNameSpace.scrollVelocityCriteria {
                        vc.navigationBar.snp.updateConstraints { $0.height.equalTo(MainFlowNavigationBarNameSpace.baseHeight) }
                        vc.navigationBar.chatRoomButton.rx.isHidden.onNext(false)
                        vc.navigationBar.titleLabel.rx.isHidden.onNext(false)
                    } else {
                        vc.navigationBar.snp.updateConstraints { $0.height.equalTo(MainFlowNavigationBarNameSpace.updateHeight) }
                        vc.navigationBar.chatRoomButton.rx.isHidden.onNext(true)
                        vc.navigationBar.titleLabel.rx.isHidden.onNext(true)
                    }
                    vc.view.layoutIfNeeded()
                }
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
            QuestionViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
