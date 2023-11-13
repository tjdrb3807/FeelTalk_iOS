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

final class ChallengeTabBarView: UIView {
    let modelList = PublishRelay<[ChallengeTabBarModel]>()
    var didTab: ((Int) -> Void)?
    private let diseposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
    
        return stackView
    }()
    
    private lazy var tabScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    lazy var highlightIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
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
            .withUnretained(self)
            .bind { v, items in
                items.enumerated()
                    .forEach { offset, item in
                        let tabBarItem = ChallengeTabBarItem()
                        tabBarItem.model.accept(item)
                        tabBarItem.titleLabel.rx.text.onNext(item.type.rawValue)
                        tabBarItem.countLabel.rx.text.onNext(String(item.count))
                        tabBarItem.snp.makeConstraints { $0.width.equalTo(UIScreen.main.bounds.width / CGFloat(items.count)) }
                        tabBarItem.tag = offset
                        tabBarItem.rx.tapGesture()
                            .when(.recognized)
                            .compactMap { $0.view?.tag }
                            .bind { tag in
                                v.didTab?(tag)
                            }.disposed(by: v.diseposeBag)
                    }
            }.disposed(by: diseposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTabScrollViewSubComponents()
    }
    
    private func setConstraints() {
        makeTabScrollViewConstraints()
        makeContentStackViewConstraints()
        makeHighlightIndicatorConstraints()
    }
}

extension ChallengeTabBarView {
    private func addViewSubComponents() { addSubview(tabScrollView) }
    
    private func makeTabScrollViewConstraints() {
        tabScrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func addTabScrollViewSubComponents() {
        [contentStackView, highlightIndicator].forEach { tabScrollView.addSubview($0) }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.edges.height.equalToSuperview() }
    }
    
    private func makeHighlightIndicatorConstraints() {
        highlightIndicator.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 2)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
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
            let v = ChallengeTabBarView()
            v.modelList.accept([ChallengeTabBarModel(type: .onGoing, count: 99),
                                ChallengeTabBarModel(type: .completed, count: 0)])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
