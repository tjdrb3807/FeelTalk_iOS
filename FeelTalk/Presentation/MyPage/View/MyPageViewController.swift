//
//  MyPageViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    var viewModel: MyPageViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    private lazy var navigationBar: MyPageNavigationBar = { MyPageNavigationBar() }()
    
    private lazy var profileView: MyPageProfileView = { MyPageProfileView() }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = MyPageViewNameSpace.tableViewCornerRadius
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: MyPageViewNameSpace.tableViewSeparatorTopInset,
                                                left: MyPageViewNameSpace.tableViewSeparatorLeftInset,
                                                bottom: MyPageViewNameSpace.tableViewSeparatorBottomInset,
                                                right: MyPageViewNameSpace.tableViewSeparatorRightInset)
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        
        tableView.register(MyPageTableViewCell.self,
                           forCellReuseIdentifier: MyPageTableViewCellNameSpace.identifier)
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
    
    private func bind(to viewModel: MyPageViewModel) {
        let input = MyPageViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                          tapPushConfigurationSettingsButton: navigationBar.pushConfigurationSettingsButton.rx.tap,
                                          tapMyProfileButton: profileView.myProfileButton.rx.tap,
                                          tapPartnerInfoButton: profileView.partnerInfoButton.rx.tap,
                                          tapTableViewCell: tableView.rx.modelSelected(MyPageTableViewCellType.self))
        
        let output = viewModel.transfer(input: input)
        
        output.userInfo
            .bind(to: profileView.userInfo)
            .disposed(by: disposeBag)
        
        output.partnerInfo
            .bind(to: profileView.partnerInfo)
            .disposed(by: disposeBag)
        
        output.cellData
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: MyPageTableViewCellNameSpace.identifier,
                                                        for: IndexPath(row: row, section: 0)) as? MyPageTableViewCell else { return UITableViewCell() }
                cell.cellType.accept(data)
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeNavigationBarConstraints()
        makeProfileViewConstraints()
        makeTableViewConstraints()
    }
}

extension MyPageViewController {
    private func addViewSubComponents() {
        [navigationBar, profileView, tableView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top).offset(MyPageNavigationBarNameSpace.height)
        }
    }
    
    private func makeProfileViewConstraints() {
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(MyPageProfileViewNameSpace.topOffset)
            $0.leading.equalToSuperview().inset(MyPageProfileViewNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(MyPageProfileViewNameSpace.trailingInset)
            $0.bottom.equalTo(profileView.snp.top).offset(MyPageProfileViewNameSpace.height)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(MyPageViewNameSpace.tableViewTopOffset)
            $0.leading.equalToSuperview().inset(MyPageViewNameSpace.tableViewLeadingInset)
            $0.trailing.equalToSuperview().inset(MyPageViewNameSpace.tableViewTrailingInset)
            $0.bottom.equalTo(tableView.snp.top).offset(MyPageViewNameSpace.tableViewBottomOffset)
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == MyPageTableViewCellNameSpace.defaultCellIndex {
            return MyPageTableViewCellNameSpace.defaultCellHeight
        } else {
            return MyPageTableViewCellNameSpace.firstOrLastCellHeight
        }
    }
}

#if DEBUG

import SwiftUI

struct MyPageViewController_Previews: PreviewProvider {
    static var previews: some View {
        MyPageViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct MyPageViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MyPageViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
