//
//  ChatFuncMenuTabBarItem.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

enum ChatFuncMenuTabBarItemType: String {
    case question = "질문"
    case challnege = "챌린지"
}

final class ChatFuncMenuTabBarItem: UIView {
    let isSelected = PublishRelay<Bool>()
    var type: ChatFuncMenuTabBarItemType
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardSemiBold,
            size: ChatFuncMeunTabBarItemNameSpace.titleLabelFontSize)
        
        isSelected
            .map { state -> UIColor in (state ? .black : UIColor(named: CommonColorNameSpace.gray400)) ?? .clear }
            .bind(to: label.rx.textColor)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var indicator: UIView = {
        let view = UIView()
        
        isSelected
            .map { state -> UIColor in state ? .black : UIColor(named: CommonColorNameSpace.gray400) ?? .clear }
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        return view
    }()
    
    init(type: ChatFuncMenuTabBarItemType) {
        self.type = type
        super.init(frame: .zero)
        
        self.titleLabel.text = type.rawValue
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeIndicatorConstraints()
    }
}

extension ChatFuncMenuTabBarItem {
    private func addViewSubComponents() {
        [titleLabel, indicator].forEach { addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func makeIndicatorConstraints() {
        indicator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(ChatFuncMeunTabBarItemNameSpace.indicatorHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatFuncMenuTabBarItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatFuncMenuTabBarItem_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: ChatFuncMeunTabBarItemNameSpace.width,
                height: ChatFuncMeunTabBarItemNameSpace.height,
                alignment: .center)
    }
    
    struct ChatFuncMenuTabBarItem_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChatFuncMenuTabBarItem(type: .question)
            v.isSelected.accept(false)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
