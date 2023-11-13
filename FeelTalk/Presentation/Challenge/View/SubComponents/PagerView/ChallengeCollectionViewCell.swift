//
//  ChallengeCollectionViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/27.
//

import UIKit
import UIKit
import RxSwift
import RxCocoa

final class ChallengeCollectionViewCell: UICollectionViewCell {
    let modelList = PublishRelay<[Challenge]>()
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
        modelList
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { cv, row, item in
                let index = IndexPath(row: row, section: ChallengeCollectionViewCellNameSpace.collectionViewDefaultSectionIndex)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChallengeCellNameSpace.identifier,
                                                        for: index) as? ChallengeCell else { return UICollectionViewCell() }
                cell.model.accept(item)
                
                return cell
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
            v.modelList.accept([.init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false)])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
