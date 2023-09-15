//
//  ChallengeCollectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCollectionView: UICollectionView {
    let challengeTotalCount = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        
        self.setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        register(ChallengePagerView.self, forCellWithReuseIdentifier: "ChallengePagerView")
        register(ChallengeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChallengeCollectionViewHeaderView")
        dataSource = self
        delegate = self
        backgroundColor = UIColor(named: "gray_100")
    }
}

extension ChallengeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengePagerView", for: indexPath) as? ChallengePagerView else { return UICollectionViewCell() }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: "ChallengeCollectionViewHeaderView",
                                                                               for: indexPath) as? ChallengeCollectionHeaderView else {
                return ChallengeCollectionHeaderView()
            }
            
            self.challengeTotalCount
                .bind(to: header.challengeTotalCount)
                .disposed(by: disposeBag)

            return header
        }

        return UICollectionReusableView()
    }
}

extension ChallengeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: frame.width, height: frame.height)
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
            ChallengeCollectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
