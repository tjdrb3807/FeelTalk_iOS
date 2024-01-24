//
//  ChallengeCollectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCollectionView: UICollectionView {
    let ongoingModelList = BehaviorRelay<[Challenge]>(value: [])
    let completedModelList = BehaviorRelay<[Challenge]>(value: [])
    let currentDisplayCell = PublishRelay<ChallengeState>()
    let selectedModel = PublishRelay<Challenge>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.bind()
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        ongoingModelList
            .withUnretained(self)
            .bind { vm, list in
                guard let ongoingCollectionViewCell = vm.cellForItem(at: IndexPath(row: 0, section: 0)) as? ChallengeCollectionViewCell else { return }
                ongoingCollectionViewCell.modelList.accept(list)

            }.disposed(by: disposeBag)
        
        completedModelList
            .withUnretained(self)
            .bind { vm, list in
                guard let completedCollectionViewCell = vm.cellForItem(at: IndexPath(row: 1, section: 0)) as? ChallengeCollectionViewCell else { return }
                
                completedCollectionViewCell.modelList.accept(list)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        isScrollEnabled = true
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        register(ChallengeCollectionViewCell.self,
                 forCellWithReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier)
        rx.setDelegate(self)
            .disposed(by: disposeBag)
        dataSource = self
    }
}

extension ChallengeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier,
                                                            for: indexPath) as? ChallengeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.selectedModel
            .bind(to: selectedModel)
            .disposed(by: disposeBag)
        
        if indexPath.row == 0 {
            cell.type = .ongoing
        } else if indexPath.row == 1 {
            cell.type = .completed
        }
        
        return cell
    }
}

extension ChallengeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        
        guard 0 <= contentOffsetX && contentOffsetX <= UIScreen.main.bounds.width else { return }
        
        if contentOffsetX == 0.0 {
            currentDisplayCell.accept(.ongoing)
        } else if contentOffsetX == UIScreen.main.bounds.width {
            currentDisplayCell.accept(.completed)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCollectionView_Presentable()
    }
    
    struct ChallengeCollectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeCollectionView()
            v.ongoingModelList
                .accept(
                    [Challenge(index: 0, pageNo: 0, title: "테스트 제목입니다.", deadline: "2024-01-23T00:00:00", content: "Hello", creator: "KakaoSG", isCompleted: false),
                     Challenge(index: 1, pageNo: 0, title: "Test01", deadline: "2024-01-30T00:00:00", content: "Hello", creator: "KakaoSG", isCompleted: false),
                     Challenge(index: 2, pageNo: 0, title: "Test02", deadline: "2024-01-31T00:00:00", content: "테스트 화면", creator: "Partner", isCompleted: false),
                     Challenge(index: 3, pageNo: 0, title: "999일 넘게 남음", deadline: "2030-01-30T00:00:00", content: "Hello", creator: "KakaoSG", isCompleted: false)])
            
            v.completedModelList.accept([Challenge(index: 0, pageNo: 0, title: "테스트01", deadline: "2024-01-30T00:00:00", content: "Hello", creator: "KakaoSG", isCompleted: true)])
            
//            v.ongoingModelList.accept([])
//            v.completedModelList.accept([])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
