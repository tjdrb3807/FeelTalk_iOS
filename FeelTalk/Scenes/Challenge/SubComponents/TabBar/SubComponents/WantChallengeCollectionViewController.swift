//
//  WantChallengeCollectionViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/15.
//

import UIKit
import SnapKit

final class WantChallengeCollectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.height / 2 - 20, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "ChallengeCollectionViewCell")
//        collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
    }
    
    private func setConfig() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension WantChallengeCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCollectionViewCell", for: indexPath) as? ChallengeCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension WantChallengeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

#if DEBUG

import SwiftUI

struct WantChallengeCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        WantChallengeCollectionViewController_Presentable()
    }
    
    struct WantChallengeCollectionViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            WantChallengeCollectionViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
