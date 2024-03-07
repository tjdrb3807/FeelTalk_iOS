//
//  ChatFuncMenuTabBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class ChatFuncMenuTabBar: UIView {
    let modelObserver = BehaviorRelay<[ChatFuncMenuTabBarItemType]>(value: [.question, .challnege])
    let selectedItem = BehaviorRelay<ChatFuncMenuTabBarItemType>(value: .question)
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .clear
        
        modelObserver
            .withUnretained(self)
            .bind { v, model in
                v.setItems(model)
            }.disposed(by: disposeBag)
        
        selectedItem
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, type in
                v.selectItem(type)
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addSubview(contentStackView)
    }
    
    private func setConstraints() {
        contentStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension ChatFuncMenuTabBar {
    private func setItems(_ typeList: [ChatFuncMenuTabBarItemType]) {
        typeList.forEach { type in
            let item = ChatFuncMenuTabBarItem(type: type)
            
            contentStackView.addArrangedSubview(item)

            item.rx.tapGesture()
                .when(.recognized)
                .map { _ -> ChatFuncMenuTabBarItemType in type }
                .bind(to: selectedItem)
                .disposed(by: disposeBag)
        }
    }
    
    private func selectItem(_ type: ChatFuncMenuTabBarItemType) {
        contentStackView.arrangedSubviews.forEach { subView in
            guard let item = subView as? ChatFuncMenuTabBarItem else { return }
            
            item.type == type ? item.isSelected.accept(true) : item.isSelected.accept(false)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatFuncMenuTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatFuncMenuTabBar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width,
                height: ChatFuncMeunTabBarItemNameSpace.height,
                alignment: .center)
    }
    
    struct ChatFuncMenuTabBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatFuncMenuTabBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
