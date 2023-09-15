//
//  ChallengePagerCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/17.
//

import UIKit
import SnapKit

final class ChallengePagerCell: UICollectionViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = (UIScreen.main.bounds.height / 100) * 1.84  // 15.0
        layout.minimumInteritemSpacing = (UIScreen.main.bounds.width / 100) * 4
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChallengeCell.self, forCellWithReuseIdentifier: "ChallengeCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "gray_200")
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubCompnents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: "gray_200")
    }
    
    private func addSubCompnents() {
        contentView.addSubview(collectionView)
    }
    
    private func setConfigurations() {
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension ChallengePagerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCell", for: indexPath) as? ChallengeCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension ChallengePagerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (frame.width / 2) - 30, height: UIScreen.main.bounds.height / 100 * 22.29)
    }
}

#if DEBUG

import SwiftUI

struct ChallengePagerCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengePagerCell_Presentable()
    }
    
    struct ChallengePagerCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengePagerCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
