//
//  WithdrawalDetailViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WithdrawalDetailViweController: UIViewController {
    weak var viewModel: WithdrawalDetailViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var selectionView: WithdrawalDetailSelectionView = { WithdrawalDetailSelectionView() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: WithdrawalDetailViewModel) {
        let input = WithdrawalDetailViewModel.Input()
        
        let output = viewModel.transfer(input: input)
        
        output.cellData
            .bind(to: selectionView.cellData)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        
    }
    
    private func addSubComponents() {
        
    }
    
    private func setConstraints() {
        
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalDetailViweController_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetailViweController_Presentable()
    }
    
    struct WithdrawalDetailViweController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            WithdrawalDetailViweController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
