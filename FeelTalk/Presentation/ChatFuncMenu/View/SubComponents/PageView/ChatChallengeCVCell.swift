//
//  ChatChallengeCVCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct ChatChallengeSection {
    var items: [Item]
}

extension ChatChallengeSection: SectionModelType {
    typealias Item = ChatChallengeCellModel
    
    init(original: ChatChallengeSection, items: [ChatChallengeCellModel]) {
        self = original
        self.items = items
    }
}

final class ChatChallengeCVCell: UICollectionViewCell {
    let modelOberver = BehaviorRelay<[ChatChallengeSection]>(value: [])
    static let selectedItemObserver = BehaviorRelay<IndexPath?>(value: nil)
    private let disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<ChatChallengeSection>(configureCell: { ds, cv, indexPath, item in
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChatChallengeCellNameSpace.identifier, for: indexPath) as? ChatChallegeCell else { return UICollectionViewCell() }
        cell.modelObserver.accept(item)
        
        return cell
    })
    
    private lazy var emptyInfoView: EmptyChallengeView = { EmptyChallengeView(state: .ongoing) }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatChallegeCell.self, forCellWithReuseIdentifier: ChatChallengeCellNameSpace.identifier)
        
        modelOberver
            .skip(1)
            .map { list -> Bool in list[0].items.isEmpty ? false : true }
            .bind(to: emptyInfoView.rx.isHidden)
            .disposed(by: disposeBag)
        
        modelOberver
            .skip(1)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable
            .zip(
                collectionView.rx.itemSelected,
                collectionView.rx.modelSelected(ChatChallengeSection.Item.self)
            ).map { (indexPath: $0, challenge: $1.model) }
            .bind { event in
                ChatChallengeCVCell.selectedItemObserver.accept(event.indexPath)
                ChatFuncMenuViewModel.selectedChallengeModelObserver.accept(event.challenge)
            }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        
    }
    
    private func addSubComponents() {
        contentView.addSubview(collectionView)
        
        collectionView.addSubview(emptyInfoView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        emptyInfoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ChatChallengeCVCellNameSpace.emptyInfoViewWidth)
            $0.height.equalTo(ChatChallengeCVCellNameSpace.emptyInfoViewHeight)
        }
    }
}

extension ChatChallengeCVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: ChallengeCellNameSpace.width,
            height: ChallengeCellNameSpace.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: ChatChallengeCVCellNameSpace.collectionViewTopInset,
            left: CommonConstraintNameSpace.leadingInset,
            bottom: ChatChallengeCVCellNameSpace.collectionViewBottomInset,
            right: CommonConstraintNameSpace.trailingInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ChatChallengeCVCellNameSpace.collectionViewMinimumLineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ChatChallengeCVCellNameSpace.collecitonViewMinimumInteritemSpace
    }
}

#if DEBUG

import SwiftUI

struct ChatChallengeCVCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatChallengeCVCell_Presentable()
    }
    
    struct ChatChallengeCVCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = ChatChallengeCVCell()
            c.modelOberver
                .accept([
                    ChatChallengeSection(
                        items: [
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
                                isSelected: false),
                            ChatChallengeCellModel(
                                model: Challenge(index: 0, pageNo: 0, title: "Test01", deadline: "2025-01-01T12:00:00", content: "Test01", creator: "KakaoSG", isCompleted: false, completeDate: nil),
                                isSelected: false)
                        ])
                ])
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif


