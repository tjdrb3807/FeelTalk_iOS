//
//  LockingSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingSettingViewController: UIViewController {
    var viewModel: LockingSettingsViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .lockingSetting) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInset = UIEdgeInsets(top: 0.0,
                                                left: 0.0,
                                                bottom: 0.0,
                                                right: 0.0)
        
        tableView.register(LockingSettingsTableViewCell.self, forCellReuseIdentifier: "LockingSettingsTableViewCell")
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: LockingSettingsViewModel) {
        let input = LockingSettingsViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                                   tapCell: tableView.rx.modelSelected(LockingSettingsModel.self))
        
        let output = viewModel.transfer(input: input)
        
        output.cellData
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "LockingSettingsTableViewCell",
                                                        for: IndexPath(row: row, section: 0)) as? LockingSettingsTableViewCell else { return UITableViewCell() }

                cell.model.accept(data)
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        [navigationBar, tableView].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
        makeTableViewConstraints()
    }
}

extension LockingSettingViewController {
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(CustomNavigationBarNameSpace.height)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension LockingSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

#if DEBUG

import SwiftUI

struct LockingSettingViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockingSettingViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LockingSettingViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let viewController = LockingSettingViewController()
            let viewModel = LockingSettingsViewModel(coordinator: DefaultLockingSettingsCoordinator(UINavigationController()))
            
            viewModel.isLockScreen.accept(false)
            viewController.viewModel = viewModel
        
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
