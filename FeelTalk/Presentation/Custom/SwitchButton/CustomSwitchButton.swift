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
    typealias SwitchColor = (bar: UIColor, circle: UIColor)
    
    let isState = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray300)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = frame.height / 2
        
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = frame.height / 2
        
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
        barView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeCircleViewConstratins() {
        circleView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(barView.snp.width).dividedBy(2)
        }
    }
}

extension CustomSwitchButton {
    
}

#if DEBUG

import SwiftUI

struct CustomSwitchButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomSwitchButton_Presentable()
    }
    
    struct CustomSwitchButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomSwitchButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
