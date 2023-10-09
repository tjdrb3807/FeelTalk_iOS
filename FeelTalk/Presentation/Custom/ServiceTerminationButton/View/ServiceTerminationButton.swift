//
//  ServiceTerminationButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationButton: UIButton {
    let type: TerminationType
    let isState = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(type: TerminationType) {
        self.type = type
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                                              height: ServiceTerminationButtonNameSpace.height)))
        self.bind()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind () {
        isState
            .withUnretained(self)
            .bind { v, state in
                v.rx.isEnabled.onNext(state)
                v.toggle(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        setTitle(type.rawValue, for: .normal)
        layer.borderWidth = ServiceTerminationButtonNameSpace.borderWidth
        layer.cornerRadius = ServiceTerminationButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
}

extension ServiceTerminationButton {
    private func toggle(with state: Bool) {
        if state {
            backgroundColor = .white
            layer.borderColor = UIColor.black.cgColor
            setTitleColor(.black, for: .normal)
            self.rx.isEnabled.onNext(state)
        } else {
            backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
            layer.borderColor = UIColor.clear.cgColor
            setTitleColor(.white, for: .normal)
            self.rx.isEnabled.onNext(state)
        }
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationButton_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: ServiceTerminationButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct ServiceTerminationButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationButton(type: .breakUp)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
