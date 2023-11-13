//
//  ChallengePagerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengePagerView: UIView {
    let model = PublishRelay<[ChallengeListModel]>()
    let isTopDrag = PublishRelay<ChallengeCollectionViewAction>()
    private let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(ChallengeCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstrinat()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { [weak self] cv, row, item in
                guard let self = self else { return UICollectionViewCell() }
                let index = IndexPath(row: row, section: 0)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier,
                                                        for: index) as? ChallengeCollectionViewCell else { return UICollectionViewCell() }
                cell.modelList.accept(item.list)
                
                cell.collectionViewAction
                    .bind(to: isTopDrag)
                    .disposed(by: disposeBag)
            
                return cell
                
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() { addSubview(collectionView) }
    
    private func setConstrinat() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChallengePagerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengePagerView()
            v.model.accept([.init(state: .ongoing,
                                  list: [.init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false)]),
                            .init(state: .completed,
                                  list: [.init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false)])
            ])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
