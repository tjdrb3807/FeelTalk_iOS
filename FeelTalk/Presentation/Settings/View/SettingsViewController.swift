//
//  SettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum LockScreenState: String {
    case on = "켜짐"
    case off = "꺼짐"
}

enum SettingsCategory: String {
    case lock = "화면잠금"
    case info = "내 필로우톡 정보"
    case changePassword = "암호변경"
    case withdrawal = "회원탈퇴"
}

struct SettingsModel: Equatable {
    let category: SettingsCategory
    var state: String?
    let isArrowIconHidden: Bool
}

struct SettingsSection {
    var header: String
    var items: [Item]
}

extension SettingsSection: SectionModelType {
    typealias Item = SettingsModel
    
    init(original: SettingsSection, items: [SettingsModel]) {
        self = original
        self.items = items
    }
}

final class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModel!
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { ds, tv, indexPath, item in
        guard let cell = tv.dequeueReusableCell(withIdentifier: SettingsCellNameSpace.identifier) as? SettingsCell else { return UITableViewCell() }
        
        cell.modelObserver.accept(item)
        cell.selectionStyle = .none
        
        return cell
    })
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(type: .settingList, isRootView: false) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCellNameSpace.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInset = UIEdgeInsets(top: SettingsViewNameSpace.tableViewSeparatorTopInset,
                                                left: SettingsViewNameSpace.tableViewSeparatorLeftInset,
                                                bottom: SettingsViewNameSpace.tableViewSeparatorBottomInset,
                                                right: SettingsViewNameSpace.tableViewSeparatorRightInset)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.sectionFooterHeight = SettingsViewNameSpace.tableViewSectionFooterHeight
        tableView.backgroundColor = .clear
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        return tableView
    }()
    
    private lazy var logOutButton: CustomBottomBorderButton = {
        CustomBottomBorderButton(title: SettingsViewNameSpace.logOutButtonTitle)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind(to viewModel: SettingsViewModel) {
        let input = SettingsViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            viewDisDisappear: rx.viewDidDisappear,
            popButtonTabObserver: navigationBar.leftButton.rx.tap,
            selectedCellObserver: tableView.rx.modelSelected(SettingsSection.Item.self),
            logoutButtonTapObserver: logOutButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.sectionObserver
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
        makeLogOutButtonConstraints()
        makeTableViewConstraints()
    }
}

extension SettingsViewController {
    private func addViewSubComponents() {
        [navigationBar, tableView, logOutButton].forEach { view.addSubview($0) }
    }
    
    private func makeLogOutButtonConstraints() {
        logOutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(SettingsViewNameSpace.logOutButtonBottomOffset)
            $0.height.equalTo(SettingsViewNameSpace.logOutButtonHeight)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SettingsCellNameSpace.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SettingsViewNameSpace.tableViewSectionHeaderHeight
    }
}

#if DEBUG

import SwiftUI
import RxSwift
import RxCocoa

struct SettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewController_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct SettingsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = SettingsViewController()
            let vm = SettingsViewModel(
                coordinator: DefaultSettingsCoordinator(
                    UINavigationController()),
                configurationUseCase: DefaultConfigurationUseCase(
                    configurationRepository: DefaultConfigurationRepository()),
                loginUseCase: DefaultLoginUseCase(
                    loginRepository: DefaultLoginRepository(),
                    appleRepository: DefaultAppleRepository(),
                    googleRepositroy: DefaultGoogleRepository(),
                    naverRepository: DefaultNaverLoginRepository(),
                    kakaoRepository: DefaultKakaoRepository(),
                    userRepository: DefaultUserRepository()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
