//
//  ChallengeCollectionViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCollectionViewCell: UICollectionViewCell {
    let model = PublishRelay<ChallengeListModel>()
    let modelSelected = PublishRelay<Challenge>()
    private let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ChallengeCell.self, forCellWithReuseIdentifier: ChallengeCellNameSpace.identifier)
        collectionView.showsVerticalScrollIndicator = true
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .filter { !$0.list.isEmpty }
            .map { $0.list }
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { [weak self] cv, row, item in
                guard let self = self else { return UICollectionViewCell() }
                let index = IndexPath(row: row, section: ChallengeCollectionViewCellNameSpace.collectionViewDefaultSectionIndex)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChallengeCellNameSpace.identifier,
                                                        for: index) as? ChallengeCell else { return UICollectionViewCell() }
                cell.model.accept(item)
                cell.modelSelected
                    .bind(to: modelSelected)
                    .disposed(by: disposeBag)
                
                return cell
            }.disposed(by: disposeBag)
        
        model
            .filter { $0.list.isEmpty }
            .map { $0.state }
            .withUnretained(self)
            .bind { cv, state in
                let emptyChallengeView = EmptyChallengeView(state: state)
                
                cv.addSubview(emptyChallengeView)
                emptyChallengeView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(EmptyChallengeViewNameSpace.topInset)
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(EmptyChallengeViewNameSpace.width)
                    $0.height.equalTo(EmptyChallengeViewNameSpace.height)
                }
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() { contentView.addSubview(collectionView) }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension ChallengeCollectionViewCell: UICollectionViewDelegateFlowLayout {
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

#if DEBUG

import SwiftUI

struct ChallengeCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCollectionViewCell_Presentable()
    }
    
    struct ChallengeCollectionViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeCollectionViewCell()
            v.model.accept(ChallengeListModel(state: .ongoing,
                                              list: [Challenge(index: 0,
                                                               pageNo: 0,
                                                               title: "Test01",
                                                               deadline: "2024-01-20T00:00:00",
                                                               content: "Hello01",
                                                               creator: "KakaoSG",
                                                               isCompleted: false)]))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
