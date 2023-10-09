//
//  LockingPasswordViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingPasswordViewController: UIViewController {
    var viewModel: LockingPasswordViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var displayView: LockingPasswordDisplayView = { LockingPasswordDisplayView() }()
    
    private lazy var keypad: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = LockingPasswordViewNameSpace.keypadLineSpace
        layout.minimumInteritemSpacing = LockingPasswordViewNameSpace.keypadItemSpacing
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3,
                                 height: LockingPasswordViewNameSpace.keypadItemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(LockingPasswordKeypadCell.self, forCellWithReuseIdentifier: LockingPasswordKeypadCellNameSpace.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
    }
    
    private func bind(to viewModel: LockingPasswordViewModel) {
        let input = LockingPasswordViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                                   tapKeypad: keypad.rx.modelSelected(LockingPasswordKeypadModel.self))
        
        let output = viewModel.transfer(input: input)
        
        output.modelList
            .drive(keypad.rx.items) { cv, row, data in
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: LockingPasswordKeypadCellNameSpace.identifier,
                                                        for: IndexPath(row: row, section: 0)) as? LockingPasswordKeypadCell else { return UICollectionViewCell() }
                cell.model.accept(data)
            
                return cell
            }.disposed(by: disposeBag)
        
        output.mode
            .bind(to: displayView.viewMode)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() { view.backgroundColor = .white }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstratins() {
        makeDisplayViewConstraints()
        makeKeypadConstraints()
    }
}

extension LockingPasswordViewController {
    private func addViewSubComponents() { [displayView, keypad].forEach { view.addSubview($0) } }
    
    private func makeDisplayViewConstraints() {
        displayView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(LockingPasswordDisplayViewNameSpace.topOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeKeypadConstraints() {
        keypad.snp.makeConstraints {
            $0.top.equalTo(keypad.snp.bottom).offset(-LockingPasswordViewNameSpace.keypadHeight)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingPasswordViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockingPasswordViewController_Presentable()
    }
    
    struct LockingPasswordViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = LockingPasswordViewController()
            let viewModel = LockingPasswordViewModel(coordinator: DefaultLockingPasswordCoordinator(UINavigationController()))
            viewModel.viewMode.accept(.settings)
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
