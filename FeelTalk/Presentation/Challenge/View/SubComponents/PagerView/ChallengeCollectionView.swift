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
    let model = PublishRelay<[ChallengeListModel]>()
    let onGoingChallengeModel = PublishRelay<[Challenge]>()
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
        model
            .asDriver(onErrorJustReturn: [])
            .drive(rx.items) { [weak self] cv, row, item in
                guard let self = self else { return UICollectionViewCell() }
                
                let index = IndexPath(row: row, section: 0)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier,
                                                        for: index) as? ChallengeCollectionViewCell else { return UICollectionViewCell() }
                cell.modelList.accept(item.list)

                return cell
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        backgroundColor = .clear
        register(ChallengeCollectionViewCell.self,
                 forCellWithReuseIdentifier: ChallengeCollectionViewCellNameSpace.identifier)
        rx.setDelegate(self).disposed(by: disposeBag)
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
