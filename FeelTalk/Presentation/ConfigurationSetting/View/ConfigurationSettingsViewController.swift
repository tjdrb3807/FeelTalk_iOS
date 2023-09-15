//
//  ConfigurationSettingsViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ConfigurationSettingsViewController: UIViewController {
    var viewModel: ConfigurationSettingsViewModel!
    
    let section: [String] = ["settings", "account", "info"]
    let model: [ConfigurationSettingsModel] = [
        ConfigurationSettingsModel(setcion: 0, title: "화면잠금", state: "켜짐"),
        ConfigurationSettingsModel(setcion: 0, title: "언어설정", state: "한국어"),
        ConfigurationSettingsModel(setcion: 1, title: "계정관리", state: nil),
        ConfigurationSettingsModel(setcion: 2, title: "개인정보처리방침", state: nil),
        ConfigurationSettingsModel(setcion: 2, title: "이용약관", state: nil),
        ConfigurationSettingsModel(setcion: 2, title: "버전정보", state: "v.1.0.1")
    ]
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: CustomNavigationBar = { CustomNavigationBar(mode: .configurationSettings) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.separatorInsetReference = .fromAutomaticInsets
        
        tableView.register(ConfigurationSettingsTableViewCell.self, forCellReuseIdentifier: "ConfigurationSettingsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    private func bind(to viewModel: ConfigurationSettingsViewModel) {
        let input = ConfigurationSettingsViewModel.Input(tapPopButton: navigationBar.leftButton.rx.tap)
        
        let _ = viewModel.transfer(input: input)
    }
    
    private func setAttributes() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeTableViewConstraints()
    }
}

extension ConfigurationSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationSettingsTableViewCell") as? ConfigurationSettingsTableViewCell else { return UITableViewCell() }
        cell.setData(with: model[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        section.count
    }
    
    
}

extension ConfigurationSettingsViewController {
    private func addViewSubComponents() {
        [navigationBar, tableView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ConfigurationSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 56 }
}

#if DEBUG

import SwiftUI

struct ConfigurationSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationSettingsViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ConfigurationSettingsViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            ConfigurationSettingsViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
