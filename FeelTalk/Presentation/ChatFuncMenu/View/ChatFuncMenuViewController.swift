//
//  ChatFuncMenuViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct ChatMenuSectionModel {
    var cellModelList: [Any]
}

struct ChatMenuSection {
    var items: [Item]
}

extension ChatMenuSection: SectionModelType {
    typealias Item = ChatMenuSectionModel
    
    init(original: ChatMenuSection, items: [ChatMenuSectionModel]) {
        self = original
        self.items = items
    }
}

final class ChatFuncMenuViewController: UIViewController {
    var scrollingByUser: Bool = false
    var viewModel: ChatFuncMenuViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    let datsSource = RxCollectionViewSectionedReloadDataSource<ChatMenuSection>(configureCell: { ds, cv, indexPath, item in
        switch indexPath.row {
        case 0:
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChatQuestionCVCellNameSpace.identifier, for: indexPath) as? ChatQuestionCVCell,
                  let modelList = item.cellModelList as? [ChatQuestionSection] else { return UICollectionViewCell() }
            cell.modelObserver.accept(modelList)
            
            return cell
        case 1:
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChatChallengeCVCellNameSpace.identifier, for: indexPath) as? ChatChallengeCVCell,
                  let modelList = item.cellModelList as? [ChatChallengeSection] else { return UICollectionViewCell() }
            cell.modelOberver.accept(modelList)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    })
    
    private lazy var navigationBar: CustomNavigationBar = {
        CustomNavigationBar(
            type: .chatFucnMneu,
            isRootView: true)
    }()
    
    private lazy var tabBar: ChatFuncMenuTabBar = {
        let tabBar = ChatFuncMenuTabBar()
        
        tabBar.selectedItem
            .withUnretained(self)
            .bind { vc, event in
                switch event {
                case .question:
                    vc.collectionView.setContentOffset(
                        CGPoint(
                            x: 0.0,
                            y: 0.0),
                        animated: true)
                case .challnege:
                    vc.collectionView.setContentOffset(
                        CGPoint(
                            x: UIScreen.main.bounds.width,
                            y: 0.0),
                        animated: true)
                }
            }.disposed(by: disposeBag)
        
        return tabBar
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ChatQuestionCVCell.self, forCellWithReuseIdentifier: ChatQuestionCVCellNameSpace.identifier)
        collectionView.register(ChatChallengeCVCell.self, forCellWithReuseIdentifier: ChatChallengeCVCellNameSpace.identifier)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return collectionView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle(ChatFuncMenuViewNameSpace.shareButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium, size: ChatFuncMenuViewNameSpace.shardButtonTitleLabelFontSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main400)
        button.layer.cornerRadius = ChatFuncMenuViewNameSpace.shareButtonCornerRadius
        button.clipsToBounds = true
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind(to viewModel: ChatFuncMenuViewModel) {
        let input = ChatFuncMenuViewModel.Input(
            viewWillAppearObserver: rx.viewWillAppear,
            collectionViewContentOffsetObserver: collectionView.rx.contentOffset,
            shareButtonTapObserver: shareButton.rx.tap,
            dismissButtonTapObserver: navigationBar.leftButton.rx.tap
        )
        
        let output = viewModel.transfer(input: input)
        
        output.section
            .skip(1)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: datsSource))
            .disposed(by: disposeBag)
        
        output.shareButtonState
            .withUnretained(self)
            .bind { vc, event in
                vc.shareButton.rx.isEnabled.onNext(event)
                event ?
                vc.shareButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
                vc.shareButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        navigationBar.makeNavigationBarConstraints()
        makeTabBarConstraints()
        makeCollectionViewConstraints()
        makeShareButtonConstraints()
    }
}

extension ChatFuncMenuViewController {
    private func addViewSubComponents() {
        [navigationBar, tabBar, collectionView, shareButton].forEach { view.addSubview($0) }
    }
    
    private func makeTabBarConstraints() {
        tabBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChatFuncMeunTabBarItemNameSpace.height)
        }
    }
    
    private func makeCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(tabBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeShareButtonConstraints() {
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(ChatFuncMenuViewNameSpace.shareButtonHeight)
        }
    }
}

extension ChatFuncMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ChatFuncMenuViewNameSpace.collectionViewMinimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ChatFuncMenuViewNameSpace.collectionViewMinimunInterItemSpacing
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        
        guard 0.0 <= contentOffsetX && contentOffsetX <= UIScreen.main.bounds.width else { return }
        
        if contentOffsetX == 0.0 {
            tabBar.selectedItem.accept(.question)
        } else if contentOffsetX == UIScreen.main.bounds.width {
            tabBar.selectedItem.accept(.challnege)
        }
        
        guard scrollingByUser else { return }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingByUser = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingByUser = false
    }
}

#if DEBUG

import SwiftUI

struct ChatFuncMenuViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChatFuncMenuViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChatFuncMenuViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = ChatFuncMenuViewController()
            let vm = ChatFuncMenuViewModel(
                coordinator: DefaultChatFuncMenuCoordinator(UINavigationController()),
                questionUseCase: DefaultQuestionUseCase(
                    questionRepository: DefaultQuestionRepository(),
                    userRepository: DefaultUserRepository()),
                challengeUseCase: DefaultChallengeUseCase(challengeRepository: DefaultChallengeRepository()))
            
            vc.viewModel = vm
            
            vc.rx.viewDidAppear
                .bind { _ in
                    vc.viewModel.chatQuestionCellModelListObserver
                        .accept([
                            ChatQuestionCellModel(
                                model: Question(index: 10, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: true,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 9, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 8, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 7, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 6, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil,partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 5, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 4, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil,isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 3, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 2, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 1, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false)
                        ])
                    
                    vc.viewModel.chatChallengeCellModelListObserver.accept([
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2024-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false),
                        ChatChallengeCellModel(
                            model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                            isSelected: false)
                    ])
                    
                }.disposed(by: vc.disposeBag)
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
