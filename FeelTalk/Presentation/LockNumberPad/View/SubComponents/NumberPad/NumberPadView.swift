//
//  NumberPadView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumberPadView: UICollectionView {
    let modelList = BehaviorRelay<[NumberPadCellModel]>(value: [
        NumberPadCellModel(cellType: .number, contentType: .one),
        NumberPadCellModel(cellType: .number, contentType: .two),
        NumberPadCellModel(cellType: .number, contentType: .three),
        NumberPadCellModel(cellType: .number, contentType: .four),
        NumberPadCellModel(cellType: .number, contentType: .five),
        NumberPadCellModel(cellType: .number, contentType: .six),
        NumberPadCellModel(cellType: .number, contentType: .seven),
        NumberPadCellModel(cellType: .number, contentType: .eight),
        NumberPadCellModel(cellType: .number, contentType: .nine),
        NumberPadCellModel(cellType: .function, contentType: .cancel),
        NumberPadCellModel(cellType: .number, contentType: .zero),
        NumberPadCellModel(cellType: .function, contentType: .confirm)
    ])
    let numberPadCellTapObserver = PublishRelay<NumberPadCellContentType>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = NumberPadViewNameSpace.minimumLineSpacing
        layout.minimumInteritemSpacing = NumberPadViewNameSpace.minimumInteritemSpacing
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3,
                                 height: NumberPadViewCellNameSpace.height)
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.bind()
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        modelList
            .asDriver(onErrorJustReturn: [])
            .drive(rx.items) { cv, row, model in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: NumberPadViewCellNameSpace.identifier, for: indexPath) as? NumberPadViewCell else { return UICollectionViewCell() }
                cell.modelObserver.accept(model)
                
                return cell
            }.disposed(by: disposeBag)
        
        rx.modelSelected(NumberPadCellModel.self)
            .map { $0.contentType }
            .bind(to: numberPadCellTapObserver)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        register(NumberPadViewCell.self, forCellWithReuseIdentifier: NumberPadViewCellNameSpace.identifier)
        backgroundColor = .white
    }
}

#if DEBUG

import SwiftUI

struct NumberPadView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPadView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: NumberPadViewNameSpace.height,
                   alignment: .center)
    }
    
    struct NumberPadView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let cv = NumberPadView()
            
            return cv
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
