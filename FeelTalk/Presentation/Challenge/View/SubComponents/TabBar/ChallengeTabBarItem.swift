

//
//  ChallengeTabBarItem.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class ChallengeTabBarItem: UIView {
    let countObserver = BehaviorRelay<Int?>(value: nil)
    let isSelected = PublishRelay<Bool>()
    var type: ChallengeTabBarItemType
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = ChallengeTabBarItemNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeTabBarItemNameSpace.titleLableTextSize)
        
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeTabBarItemNameSpace.countLabelTextSize)
        
        return label
    }()
    
    private lazy var indicator: UIView = {
        let view = UIView()
        
        return view
    }()
    
    init(type: ChallengeTabBarItemType) {
        self.type = type
        super.init(frame: .zero)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind () {
        countObserver
            .compactMap { $0 }
            .map { String($0) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        isSelected
            .withUnretained(self)
            .bind { v, state in
                v.updateTitleLabelProperties(with: state)
                v.updateCountLabelProperties(with: state)
                v.updateIndicatorProperties(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear}
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeContentStackViewConstraints()
        makeIndicatorConstraints()
    }
}

extension ChallengeTabBarItem {
    private func addViewSubComponents() {
        [contentStackView, indicator].forEach { addSubview($0) }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func makeIndicatorConstraints() {
        indicator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(ChallengeTabBarItemNameSpace.indicatorHeight)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel, countLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension ChallengeTabBarItem {
    private func updateTitleLabelProperties(with isSelected: Bool) {
        isSelected ?
        titleLabel.rx.textColor.onNext(.black) :
        titleLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray600))
    }
    
    private func updateCountLabelProperties(with isSelected: Bool) {
        switch type {
        case .ongoing:
            isSelected ?
            countLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
            countLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main400))
        case .completed:
            isSelected ?
            countLabel.rx.textColor.onNext(.black) :
            countLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray400))
        }
    }
    
    private func updateIndicatorProperties(with isSelected: Bool) {
        switch type {
        case .ongoing:
            isSelected ?
            indicator.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
            indicator.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
        case .completed:
            isSelected ?
            indicator.rx.backgroundColor.onNext(.black) :
            indicator.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray500))
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeTabBarItem_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTabBarItem_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width / 2,
                   height: 48,
                   alignment: .center)
    }
    
    struct ChallengeTabBarItem_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeTabBarItem(type: .ongoing)
            v.countObserver.accept(999)
            v.isSelected.accept(true)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
