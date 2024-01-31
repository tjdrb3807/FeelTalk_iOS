//
//  AccountInfoSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct AccountInfoSettingsSection {
    var items: [Item]
}

extension AccountInfoSettingsSection: SectionModelType {
    typealias Item = SettingsModel
    
    init(original: AccountInfoSettingsSection, items: [SettingsModel]) {
        self = original
        self.items = items
    }
}

final class AccountInfoSettingsViewController: UIViewController {
    var viewModel: AccountInfoSettingsViewModel!
    let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .accountInfo, isRootView: false) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCellNameSpace.identifier)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInset = UIEdgeInsets(top: AccountInfoSettingsViewNameSpace.tableViewSeparatorTopInset,
                                                left: AccountInfoSettingsViewNameSpace.tableViewSeparatorLeftInset,
                                                bottom: AccountInfoSettingsViewNameSpace.tableViewSeparatorBottomInset,
                                                right: AccountInfoSettingsViewNameSpace.tableViewSeparatorRightInset)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.sectionFooterHeight = AccountInfoSettingsViewNameSpace.tableViewSectionFooterHeight
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: AccountInfoSettingsViewModel) {
        let dataSource = RxTableViewSectionedReloadDataSource<AccountInfoSettingsSection>(configureCell: { ds, tv, indexPath, item in
            guard let cell = tv.dequeueReusableCell(withIdentifier: SettingsCellNameSpace.identifier) as? SettingsCell else { return UITableViewCell() }
            cell.modelObserver.accept(item)
            cell.selectionStyle = .none
            
            return cell
        })

        let input = AccountInfoSettingsViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            popButtonTapObserver: navigationBar.leftButton.rx.tap,
            selectedCellObserver: tableView.rx.modelSelected(AccountInfoSettingsSection.Item.self))
        
        let output = viewModel.transfer(input: input)
        
        output.sectionObserver
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setProperties() { view.backgroundColor = .white }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeTableViewConstraints()
    }
}

extension AccountInfoSettingsViewController {
    private func addViewSubComponents() {
        [navigationBar, tableView].forEach { view.addSubview($0) }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension AccountInfoSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SettingsCellNameSpace.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        AccountInfoSettingsViewNameSpace.tableViewSectionHeaderHeight
    }
}

#if DEBUG

import SwiftUI
import RxSwift
import RxCocoa

struct AccountInfoSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoSettingsViewController_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct AccountInfoSettingsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = AccountInfoSettingsViewController()
            let vm = AccountInfoSettingsViewModel(coordinator: DefaultAccountInfoSettingsCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
