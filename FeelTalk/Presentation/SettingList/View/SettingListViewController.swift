//
//  SettingListViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class SettingListViewController: UIViewController {
    var viewModel: SettingListViewModel!
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SettingListSectionModel>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingListCellNameSpace.identifier,
                                                       for: indexPath) as? SettingListCell else { return UITableViewCell() }
        
        cell.model.accept(item)
        cell.selectionStyle = .none
        
        return cell
    })
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .settingList) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.register(SettingListCell.self, forCellReuseIdentifier: SettingListCellNameSpace.identifier)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInset = UIEdgeInsets(top: 0.0,
                                                left: 0.0,
                                                bottom: 0.0,
                                                right: 0.0)
        
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
    
    private func bind(to viewModel: SettingListViewModel) {
        let input = SettingListViewModel.Input(viewWillAppear: self.rx.viewWillAppear)
        
        let output = viewModel.transfer(input: input)
        
        output.sectionModel
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addSettingListViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeTableViewConstraints()
    }
}

/// Default ui settings method
extension SettingListViewController {
    private func addSettingListViewSubComponents() {
        [navigationBar, tableView].forEach { view.addSubview($0) }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SettingListCellNameSpace.height
    }
}

#if DEBUG

import SwiftUI

struct SettingListViewController_Previews: PreviewProvider {
    static var previews: some View {
        SettingListViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct SettingListViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = SettingListViewController()
            let vm = SettingListViewModel(coordinatro: DefaultSettionListCoordinator(UINavigationController()),
                                          configurationUseCase: DefaultConfigurationUseCase(configurationRepository: DefaultConfigurationRepository()))
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
