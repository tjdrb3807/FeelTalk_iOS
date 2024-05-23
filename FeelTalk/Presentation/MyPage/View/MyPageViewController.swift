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
    
    private lazy var navigationBar: MainNavigationBar = { MainNavigationBar(type: .myPage) }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.indicatorStyle = .black
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPageViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var topSpacingView: UIView = { UIView() }()
    
    lazy var profileView: MyPageProfileView = { MyPageProfileView() }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.borderColor = UIColor(named: CommonColorNameSpace.gray200)?.cgColor
        tableView.layer.borderWidth = MyPageViewNameSpace.borderWidth
        tableView.layer.cornerRadius = MyPageViewNameSpace.tableViewCornerRadius
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: MyPageViewNameSpace.tableViewSeparatorTopInset,
                                                left: MyPageViewNameSpace.tableViewSeparatorLeftInset,
                                                bottom: MyPageViewNameSpace.tableViewSeparatorBottomInset,
                                                right: MyPageViewNameSpace.tableViewSeparatorRightInset)
        tableView.separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        tableView.isScrollEnabled = false
        
        tableView.register(MyPageTableViewCell.self,
                           forCellReuseIdentifier: MyPageTableViewCellNameSpace.identifier)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    private lazy var bottomSheet: CustomBottomSheetView = { CustomBottomSheetView() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind(to viewModel: MyPageViewModel) {
        let input = MyPageViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                          tapPartnerInfoButton: profileView.partnerInfoButton.rx.tap,
                                          tapTableViewCell: tableView.rx.modelSelected(MyPageTableViewCellType.self),
                                          tapChatRoomButton: navigationBar.chatRoomButton.rx.tap)
        
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
        
        output.showBottomSheet
            .withUnretained(self)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler())
            .bind { vc, type in
                vc.bottomSheet.type.accept(type)
                guard !vc.view.subviews.contains(where: {
                    $0 is CustomBottomSheetView
                }) else { return }
                let bottomSheet = vc.bottomSheet
                vc.view.addSubview(bottomSheet)
                bottomSheet.snp.makeConstraints { $0.edges.equalToSuperview()}
                vc.view.layoutIfNeeded()

                bottomSheet.show(type: type)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addScrollViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConfigurations() {
        navigationBar.makeMainNavigationBarConstraints()
        makeScrollViewConstraints()
        makeContentStackViewConstraints()
        makeTopSpacingViewConstraints()
        makeProfileViewConstraints()
        makeTableViewConstraints()
    }
}

extension MyPageViewController {
    private func addViewSubComponents() { [navigationBar, scrollView].forEach { view.addSubview($0) } }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.left.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addScrollViewSubComponents() { scrollView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [topSpacingView, profileView, tableView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTopSpacingViewConstraints() {
        topSpacingView.snp.makeConstraints { $0.height.equalTo(MyPageViewNameSpace.topSpacingViewHeight) }
    }
    
    private func makeProfileViewConstraints() {
        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(MyPageProfileViewNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(MyPageProfileViewNameSpace.trailingInset)
            $0.bottom.equalTo(profileView.snp.top).offset(MyPageProfileViewNameSpace.height)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
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
            let viewController = MyPageViewController()
            let viewModel = MyPageViewModel(coordinator: DefaultMyPageCoordinator(UINavigationController()),
                                            userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
    
            viewController.profileView.userInfo.accept(MyInfo(id: 0, nickname: "SeooongGyu", snsType: .apple))
            viewController.profileView.partnerInfoButton.partnerInfo.accept(PartnerInfo(nickname: "Partner", snsType: .naver))
        
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
