//
//  ChallengeTabBarView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class ChallengeTabBar: UIView {
    let modelList = PublishRelay<[ChallengeTabBarModel]>()
    let selectedItem = PublishRelay<ChallengeTabBarItemType>()
    private let disposeBag = DisposeBag()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubcomponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        modelList
            .withUnretained(self)
            .bind { v, modelList in
                v.setItems(modelList)
            }.disposed(by: disposeBag)
        
        selectedItem
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, type in
                v.selectItem(type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubcomponents() { addSubview(contentStackView) }
    
    private func setConstratins() {
        contentStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension ChallengeTabBar {
    private func setItems(_ modelList: [ChallengeTabBarModel]) {
        modelList.forEach { model in
            let item = ChallengeTabBarItem(type: model.type)
            
            self.contentStackView.addArrangedSubview(item)
            
            item.countObserver.accept(model.count)
            
            item.rx.tapGesture()
                .when(.recognized)
                .map { _ in item.type }
                .bind(to: selectedItem)
                .disposed(by: disposeBag)
        }
    }
    
    private func selectItem(_ type: ChallengeTabBarItemType) {
        self.contentStackView.arrangedSubviews.forEach {
            guard let item = $0 as? ChallengeTabBarItem else { return }
            
            item.type == type ? item.isSelected.accept(true) : item.isSelected.accept(false)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTabBarView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeTabBarNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeTabBarView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeTabBar()
            v.modelList.accept([ChallengeTabBarModel(type: .ongoing, count: 100),
                                ChallengeTabBarModel(type: .completed, count: 5)])
            v.selectedItem.accept(.ongoing)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
