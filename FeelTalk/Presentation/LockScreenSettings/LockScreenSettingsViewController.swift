//
//  LockScreenSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct LockScreenSettingsSection {
    var items: [Item]
}

extension LockScreenSettingsSection: SectionModelType {
    typealias Item = SettingsModel
    
    init(original: LockScreenSettingsSection, items: [SettingsModel]) {
        self = original
        self.items = items
    }
}

final class LockScreenSettingsViewController: UIViewController {
    var viewModel: LockScreenSettingsViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .lockScreenSettings, isRootView: false) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCellNameSpace.identifier)
        tableView.register(LockScreenSettingsCell.self, forCellReuseIdentifier: "LockScreenSettingsCell")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInset = UIEdgeInsets(top: 0.0,
                                                left: 0.0,
                                                bottom: 0.0,
                                                right: 0.0)
        tableView.backgroundColor = .clear
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    var sections = BehaviorRelay<[LockScreenSettingsSection]>(value: [
        LockScreenSettingsSection(items: [SettingsModel(category: .lock, state: LockScreenState.on.rawValue, isArrowIconHidden: false),
                                          SettingsModel(category: .changePassword, isArrowIconHidden: false)])])
    
    private func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<LockScreenSettingsSection>(configureCell: { ds, tv, indexPath, item in
            if item.category == .lock {
                guard let cell = tv.dequeueReusableCell(withIdentifier: "LockScreenSettingsCell") as? LockScreenSettingsCell else { return UITableViewCell() }
                cell.modelObserver.accept(item)
                
                return cell
            } else if item.category == .changePassword {
                guard let cell = tv.dequeueReusableCell(withIdentifier: SettingsCellNameSpace.identifier) as? SettingsCell else { return UITableViewCell() }
                cell.modelObserver.accept(item)
                
                return cell
            }
            
            return UITableViewCell()
        })
        
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeTableViewConstraints()
    }
}

extension LockScreenSettingsViewController {
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

extension LockScreenSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0
    }
}

#if DEBUG

import SwiftUI

struct LockScreenSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenSettingsViewController_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct LockScreenSettingsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockScreenSettingsViewController()
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
