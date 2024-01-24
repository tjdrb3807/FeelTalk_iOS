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
    var type: ChallengeState?
    let modelList = PublishRelay<[Challenge]>()
    let selectedModel = PublishRelay<Challenge>()
    let selectedIndex = BehaviorRelay<Int?>(value: nil)
    var items: [Challenge] = []
    
    private let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ChallengeCell.self, forCellWithReuseIdentifier: ChallengeCellNameSpace.identifier)
        collectionView.showsVerticalScrollIndicator = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private lazy var emptyChallengeView: EmptyChallengeView = {
        let view = EmptyChallengeView(state: type ?? .ongoing)
        
        return view
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
        modelList
            .withUnretained(self)
            .bind { v, list in
                list.forEach { v.items.append($0) }
                v.collectionView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addCellSubComponents()
    }
    
    private func setConstraints() {
        makeCollectionViewConstraints()
        makeEmptyChallengeViewConstraints()
    }
}

extension ChallengeCollectionViewCell {
    private func addCellSubComponents() {
        [collectionView, emptyChallengeView].forEach { contentView.addSubview($0) }
    }
    
    private func makeCollectionViewConstraints(){
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeEmptyChallengeViewConstraints() {
        emptyChallengeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(EmptyChallengeViewNameSpace.topInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(EmptyChallengeViewNameSpace.width)
            $0.height.equalTo(EmptyChallengeViewNameSpace.height)
        }
    }
}

extension ChallengeCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count == 0 {
            emptyChallengeView.rx.isHidden.onNext(false)
        } else {
            emptyChallengeView.rx.isHidden.onNext(true)
        }
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCellNameSpace.identifier,
                                                            for: indexPath) as? ChallengeCell else { return UICollectionViewCell() }
        cell.model.accept(items[indexPath.row])
        cell.itemsIndex = indexPath.row
        
        cell.selectedModel
            .bind(to: selectedModel)
            .disposed(by: disposeBag)
        
        cell.selectedCellItemsIndex
            .bind(to: selectedIndex)
            .disposed(by: disposeBag)
        
        return cell
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
            
            v.modelList.accept([Challenge(index: 0,
                                          pageNo: 0,
                                          title: "Test01",
                                          deadline: "2024-01-30T00:00:00",
                                          content: "Hello",
                                          creator: "KakaoSG",
                                          isCompleted: false)])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
