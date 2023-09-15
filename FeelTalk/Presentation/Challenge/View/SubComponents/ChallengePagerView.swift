//
//  ChallengePagerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/17.
//

import UIKit
import SnapKit

final class ChallengePagerView: UICollectionViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        
        collectionView.register(ChallengePagerCell.self, forCellWithReuseIdentifier: "ChallengePagerCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        
    }
    
    private func addSubComponents() {
        contentView.addSubview(collectionView)
    }
    
    private func setConfigurations() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview()}
    }
}

extension ChallengePagerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengePagerCell", for: indexPath) as? ChallengePagerCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

extension ChallengePagerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        frame.size
    }
}

#if DEBUG

import SwiftUI

struct ChallengePagerView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengePagerView_Presentable()
    }
    
    struct ChallengePagerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengePagerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
