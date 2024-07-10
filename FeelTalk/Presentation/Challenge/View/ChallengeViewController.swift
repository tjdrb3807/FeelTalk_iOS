//
//  ChallengeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeViewController: UIViewController {
    var viewModel: ChallengeViewModel!
    let innerScrollViewContentOffsetY = PublishRelay<CGFloat>()
    var innerScrollingDownDueToOuterScroll = false
    private let disposeBag = DisposeBag()
    
    private lazy var navigationBar: MainNavigationBar = { MainNavigationBar(type: .challenge) }()
    
    lazy var outerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    fileprivate lazy var countingView: ChallengeCountingView = { ChallengeCountingView() }()
    
    private lazy var spacingView: UIView = { UIView() }()
    
    fileprivate lazy var tabBar: ChallengeTabBar = { ChallengeTabBar() }()
    
    fileprivate lazy var collectionView: ChallengeCollectionView = { ChallengeCollectionView() }()
    
    private lazy var addButton: ChallengeAddButton = { ChallengeAddButton() }()
    
    var innerScrollView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        
        // MARK: Mixpanel Navigate Page
        MixpanelRepository.shared.navigatePage()
    }
    
    private func bind(to viewModel: ChallengeViewModel) {
        let isPagination = PublishRelay<Bool>()

        let input = ChallengeViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                             tapAddButton: addButton.rx.tap,
                                             tapChallengeCell: collectionView.selectedModel.asObservable(),
                                             isPagination: isPagination.asObservable(),
                                             currentDisplayCell: collectionView.currentDisplayCell,
                                             tapChatRoomButton: navigationBar.chatRoomButton.rx.tap)
        
        let output = viewModel.transfer(input: input)

        output.totalCount
            .bind(to: countingView.model)
            .disposed(by: disposeBag)
        
        output.tabBarModelList
            .bind(to: tabBar.modelList)
            .disposed(by: disposeBag)
        
        output.selectedTabBarItem
            .bind(to: tabBar.selectedItem)
            .disposed(by: disposeBag)
        
        output.ongoingModelList
            .bind(to: collectionView.ongoingModelList)
            .disposed(by: disposeBag)
        
        output.completedModelList
            .bind(to: collectionView.completedModelList)
            .disposed(by: disposeBag)
        
        output.addChallenge
            .withUnretained(self)
            .bind { vc, _ in
                guard let currentTotalCount = vc.countingView.model.value,
                      let ongoingTBI = vc.tabBar.contentStackView.subviews[0] as? ChallengeTabBarItem,
                      let currentOngingCount = ongoingTBI.countObserver.value,
                      let ongoingCell = vc.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell else { return }
                
                vc.countingView.model.accept(currentTotalCount + 1)
                ongoingTBI.countObserver.accept(currentOngingCount + 1)
                ongoingCell.items.removeAll()
            }.disposed(by: disposeBag)
        
        output.removeChallenge
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .ongoing:
                    guard let currentTotalCount = vc.countingView.model.value,
                          let ongoingTBI = vc.tabBar.contentStackView.subviews[0] as? ChallengeTabBarItem,
                          let currentOngingCount = ongoingTBI.countObserver.value,
                          let ongoingCell = vc.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell,
                          let selectedChallengeCellItemIndex = ongoingCell.selectedIndex.value else { return }
                    
                    vc.countingView.model.accept(currentTotalCount - 1)
                    ongoingTBI.countObserver.accept(currentOngingCount - 1)
                    ongoingCell.items.remove(at: selectedChallengeCellItemIndex)
                    ongoingCell.collectionView.reloadData()
                    ongoingCell.selectedIndex.accept(nil)
                case .completed:
                    guard let currentTotalCount = vc.countingView.model.value,
                          let completedTBI = vc.tabBar.contentStackView.subviews[1] as? ChallengeTabBarItem,
                          let currentCompletedCount = completedTBI.countObserver.value,
                          let completedCell = vc.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? ChallengeCollectionViewCell,
                          let selectedChallengeCellItemIndex = completedCell.selectedIndex.value else { return }
                    
                    vc.countingView.model.accept(currentTotalCount - 1)
                    completedTBI.countObserver.accept(currentCompletedCount - 1)
                    vc.collectionView.completedItemList.remove(at: selectedChallengeCellItemIndex)
                    completedCell.items.remove(at: selectedChallengeCellItemIndex)
                    completedCell.collectionView.reloadData()
                    completedCell.selectedIndex.accept(nil)
                }
            }.disposed(by: disposeBag)
        
        output.modifyChallenge
            .withUnretained(self)
            .bind { vc, _ in
                guard let ongoingCell = vc.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell else { return }
                
                ongoingCell.items.removeAll()
            }.disposed(by: disposeBag)
        
        output.completeChallenge
            .withUnretained(self)
            .bind { vc, _ in
                guard let ongoingTBI = vc.tabBar.contentStackView.subviews[0] as? ChallengeTabBarItem,
                      let currentOngoingCount = ongoingTBI.countObserver.value,
                      let completedTBI = vc.tabBar.contentStackView.subviews[1] as? ChallengeTabBarItem,
                      let currentCompletedCount = completedTBI.countObserver.value,
                      let ongoingCell = vc.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell,
                      let selectedChallengeCellItemIndex = ongoingCell.selectedIndex.value else { return }
                
                ongoingTBI.countObserver.accept(currentOngoingCount - 1)
                completedTBI.countObserver.accept(currentCompletedCount + 1)
                ongoingCell.items.remove(at: selectedChallengeCellItemIndex)
                ongoingCell.collectionView.reloadData()
                vc.collectionView.completedItemList.removeAll()
                ongoingCell.selectedIndex.accept(nil)
            }.disposed(by: disposeBag)
        
        innerScrollViewContentOffsetY
            .withUnretained(self)
            .bind { vc, offsetY in
                guard let innerScrollViewHeight = vc.innerScrollView?.contentSize.height else { return }
                let paginationY = offsetY * 50

                offsetY > innerScrollViewHeight - paginationY ?
                isPagination.accept(true) :
                isPagination.accept(false)
            }.disposed(by: disposeBag)
        
        // 초기 innerScrollView 설정
        rx.viewDidAppear
            .take(1)
            .withUnretained(self)
            .bind { vc, _ in
                guard let ongoingCV = vc.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell else { return }
                let innerScrollView = ongoingCV.collectionView
                
                innerScrollView.delegate = self
                innerScrollView.numberOfItems(inSection: 0) < 6 ?
                vc.outerScrollView.rx.isScrollEnabled.onNext(false) :
                vc.outerScrollView.rx.isScrollEnabled.onNext(true)
                vc.innerScrollView = innerScrollView
            }.disposed(by: disposeBag)
        
        // ChallengeCollectionView contentOffsetX 에 따른 innerScrollView 설정
        collectionView.currentDisplayCell
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { vc, currentCVType in
                var row: Int
                if currentCVType == .ongoing { row = 0 } else { row = 1 }
                
                guard let currentCV = vc.collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? ChallengeCollectionViewCell else { return }
                currentCV.collectionView.delegate = self
                vc.innerScrollView = currentCV.collectionView
                
                currentCV.collectionView.numberOfItems(inSection: 0) < 6 ?
                vc.outerScrollView.rx.isScrollEnabled.onNext(false) :
                vc.outerScrollView.rx.isScrollEnabled.onNext(true)
            }.disposed(by: disposeBag)
        
        tabBar.selectedItem
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .ongoing:
                    vc.collectionView.setContentOffset(CGPoint(x: 0.0,
                                                               y: 0.0),
                                                       animated: true)
                case .completed:
                    vc.collectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width,
                                                               y: 0.0),
                                                       animated: true)
                }
            }.disposed(by: disposeBag)
        
        collectionView.currentDisplayCell
            .withUnretained(self)
            .bind { vc, type in
                switch type {
                case .ongoing:
                    vc.tabBar.selectedItem.accept(.ongoing)
                case .completed:
                    vc.tabBar.selectedItem.accept(.completed)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addOutScrollViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeMainNavigationBarConstraints()
        makeOuterScrollViewConstraints()
        makeAddButtonConstraints()
        makeContentStackViewConstraints()
        makeCountingViewConstraints()
        makeSpacingViewConstraints()
        makeTabBarConstraints()
        makeCollectionViewConstraints()
    }
}

extension ChallengeViewController {
    private func addViewSubComponents() {
        [outerScrollView, navigationBar, addButton].forEach { view.addSubview($0) }
    }
    
    private func makeOuterScrollViewConstraints() {
        outerScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addOutScrollViewSubComponents() { outerScrollView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [countingView, spacingView, tabBar, collectionView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeCountingViewConstraints() {
        countingView.snp.makeConstraints { $0.height.equalTo(ChallengeCountingViewNameSpace.Height) }
    }
    
    private func makeSpacingViewConstraints() {
        spacingView.snp.makeConstraints { $0.height.equalTo(ChallengeCollectionViewNameSpace.spacingViewHeight) }
    }
    
    private func makeTabBarConstraints() {
        tabBar.snp.makeConstraints { $0.height.equalTo(ChallengeTabBarNameSpace.height) }
    }
    
    private func makeCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height - (
                Utils.safeAreaTopInset() +
                MainNavigationBarNameSpace.height +
                ChallengeCollectionViewNameSpace.spacingViewHeight +
                ChallengeTabBarNameSpace.height +
                MainTabBarNameSpace.height +
                Utils.safeAreaBottomInset()
            ))
        }
    }
    
    private func makeAddButtonConstraints() {
        addButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ChallengeAddButtonNameSpace.bottomInset)
            $0.width.equalTo(ChallengeAddButtonNameSpace.width)
            $0.height.equalTo(ChallengeAddButtonNameSpace.height)
        }
    }
}

extension ChallengeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: ChallengeCellNameSpace.width, height: ChallengeCellNameSpace.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: ChallengeCollectionViewCellNameSpace.collectionViewSectionTopInset,
                     left: CommonConstraintNameSpace.leadingInset,
                     bottom: ChallengeCollectionViewCellNameSpace.collectionViewSectionBottomInset,
                     right: CommonConstraintNameSpace.trailingInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ChallengeCollectionViewCellNameSpace.collectionViewMinLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ChallengeCollectionViewCellNameSpace.collectionViewMinItemSpacing
    }
}
/// Nested scroll
/// https://ios-development.tistory.com/1247
extension ChallengeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerScroll = outerScrollView == scrollView
        let innerScroll = !outerScroll
        let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < ChallengeCollectionViewNameSpace.zeroOffsetY
        let lessScroll = !moreScroll
        
        guard let innerScrollView = self.innerScrollView else { return }
        
        innerScrollViewContentOffsetY.accept(innerScrollView.contentOffset.y)
        
        let outerScrollMaxOffsetY = ChallengeCountingViewNameSpace.Height
        let innerScrollMaxOffsetY = innerScrollView.contentSize.height - innerScrollView.frame.height
        
        if outerScroll && moreScroll {
            guard outerScrollMaxOffsetY < outerScrollView.contentOffset.y + ChallengeCollectionViewNameSpace.floatingPointTolerance else { return }
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            guard innerScrollView.contentOffset.y < innerScrollMaxOffsetY else { return }
            
            innerScrollView.contentOffset.y = innerScrollView.contentOffset.y + outerScrollView.contentOffset.y - outerScrollMaxOffsetY
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        if outerScroll && lessScroll {
            guard innerScrollView.contentOffset.y > ChallengeCollectionViewNameSpace.zeroOffsetY && outerScrollView.contentOffset.y < outerScrollMaxOffsetY else { return }
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            innerScrollView.contentOffset.y = max(innerScrollView.contentOffset.y - (outerScrollView.contentOffset.y), ChallengeCollectionViewNameSpace.zeroOffsetY)
            
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        if innerScroll && lessScroll {
            defer { innerScrollView.lastOffsetY = innerScrollView.contentOffset.y }
            guard innerScrollView.contentOffset.y < ChallengeCollectionViewNameSpace.zeroOffsetY && outerScrollView.contentOffset.y > ChallengeCollectionViewNameSpace.zeroOffsetY else { return }
            
            guard innerScrollView.lastOffsetY > innerScrollView.contentOffset.y else { return }
            
            let moveOffset = outerScrollMaxOffsetY - abs(innerScrollView.contentOffset.y) * 3
            guard moveOffset < outerScrollView.contentOffset.y else { return }
            outerScrollView.contentOffset.y = max(moveOffset, ChallengeCollectionViewNameSpace.zeroOffsetY)
        }
        
        if innerScroll && moreScroll {
            guard
                outerScrollView.contentOffset.y + ChallengeCollectionViewNameSpace.floatingPointTolerance < outerScrollMaxOffsetY,
                !innerScrollingDownDueToOuterScroll
            else { return }
            
            let minOffsetY = min(outerScrollView.contentOffset.y + innerScrollView.contentOffset.y, outerScrollMaxOffsetY)
            let offsetY = max(minOffsetY, ChallengeCollectionViewNameSpace.zeroOffsetY)
            outerScrollView.contentOffset.y = offsetY
            
            innerScrollView.contentOffset.y = ChallengeCollectionViewNameSpace.zeroOffsetY
        }
    }
}

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}

extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChallengeViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = ChallengeViewController()
            let vm = ChallengeViewModel(coordinator: DefaultChallengeCoordinator(UINavigationController()),
                                        challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
            vc.viewModel = vm
            vc.countingView.model.accept(101)
            vc.tabBar.modelList.accept([ChallengeTabBarModel(type: .ongoing, count: 99),
                                        ChallengeTabBarModel(type: .completed, count: 2)])
            vc.tabBar.selectedItem.accept(.ongoing)
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
