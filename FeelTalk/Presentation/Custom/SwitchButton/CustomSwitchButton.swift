//
//  CustomSwitchButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomSwitchButton: UIButton {
    let isState = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray300)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CustomSwitchButtonNameSpace.barViewCornerRadius
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CustomSwitchButtonNameSpace.circleViewCornerRadius
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isState
            .withUnretained(self)
            .bind { v, state in
                v.updateState(with: state)
            }.disposed(by: disposeBag)
        
        self.rx.tap
            .withLatestFrom(isState)
            .withUnretained(self)
            .bind { v, state in
                v.isState.accept(!state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addButtonSubComponents()
    }
    
    private func setConstratins() {
        makeBarViewConstratins()
        makeCircleViewConstratins()
    }
}

extension CustomSwitchButton {
    private func addButtonSubComponents() {
        [barView, circleView].forEach { addSubview($0) }
    }
    
    private func makeBarViewConstratins() {
        barView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(CustomSwitchButtonNameSpace.barViewWidth)
            $0.height.equalTo(CustomSwitchButtonNameSpace.barViewHeight)
        }
    }
    
    private func makeCircleViewConstratins() {
        circleView.snp.makeConstraints {
            $0.centerY.equalTo(barView)
            $0.centerX.equalTo(barView).offset(CustomSwitchButtonNameSpace.circleViewOnStateCenterXOffset)
            $0.width.equalTo(CustomSwitchButtonNameSpace.circleViewWidth)
            $0.height.equalTo(CustomSwitchButtonNameSpace.circleViewHeight)
        }
    }
}

extension CustomSwitchButton {
    private func updateBarView(with state: Bool) {
        state ?
        barView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
        barView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray300))
    }
    
    private func updateCircleView(with state: Bool) {
        state ?
        circleView.snp.updateConstraints { $0.centerX.equalTo(self.barView).offset(CustomSwitchButtonNameSpace.circleViewOnStateCenterXOffset) } :
        circleView.snp.updateConstraints { $0.centerX.equalTo(self.barView).offset(CustomSwitchButtonNameSpace.circleViewOffStateCenterXOffset) }
    }
    
    private func updateState(with state: Bool) {
        updateBarView(with: state)
        updateCircleView(with: state)
        
        UIView.animate(withDuration: CustomSwitchButtonNameSpace.animationDuration,
                       delay: CustomSwitchButtonNameSpace.animationDelay,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

#if DEBUG

import SwiftUI

struct CustomSwitchButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomSwitchButton_Presentable()
    }
    
    struct CustomSwitchButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let button = CustomSwitchButton()
            button.isState.accept(true)
            
            return button
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
