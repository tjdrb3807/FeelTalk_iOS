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
    let displayCell = PublishRelay<UICollectionView>()
    private let disposeBag = DisposeBag()
    
    var innerScrollingDownDueToOuterScroll = false
    
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
    }
    
    private func bind(to viewModel: ChallengeViewModel) {
        let input = ChallengeViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                             tapAddButton: addButton.rx.tap,
                                             tapChallengeCell: collectionView.modelSelected.asObservable())
        
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
        
        output.challengeModelList
            .bind(to: collectionView.model)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .compactMap { $0.cell as? ChallengeCollectionViewCell }
            .map { $0.collectionView }
            .bind(to: displayCell)
            .disposed(by: disposeBag)
        
        displayCell
            .bind(onNext: { [weak self] cv in
                guard let self = self else { return }
                cv.delegate = self
                self.innerScrollView = cv
                cv.numberOfItems(inSection: 0) < 6 ?
                self.outerScrollView.rx.isScrollEnabled.onNext(false) :
                self.outerScrollView.rx.isScrollEnabled.onNext(true)
            }).disposed(by: disposeBag)
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
            vc.collectionView.model.accept([.init(state: .ongoing,
                                                  list: [.init(index: 0,
                                                               pageNo: 0,
                                                               title: "hello",
                                                               deadline: "2024-02-11",
                                                               content: "bye",
                                                               creator: "KakaoSG",
                                                               isCompleted: false)]),
                                            .init(state: .completed, list: [.init(index: 0,
                                                                                  pageNo: 0,
                                                                                  title: "hh",
                                                                                  deadline: "2024-01-01",
                                                                                  content: "???",
                                                                                  creator: "SG",
                                                                                  isCompleted: true)])])
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
