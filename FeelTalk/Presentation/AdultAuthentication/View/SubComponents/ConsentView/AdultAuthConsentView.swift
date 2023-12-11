//
//  AdultAuthConsentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthConsentView: UIStackView {
    let isWarningViewHidden = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    lazy var consentButton: AdultAuthConsentButton = { AdultAuthConsentButton() }()
    
    private lazy var warningView: AdultAuthWarningView = { AdultAuthWarningView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = AdultAuthConsentViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func bind () {
        isWarningViewHidden
            .bind(to: warningView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() {
        makeConsentButtonConstraints()
        makeWarningViewConstraints()
    }
}

extension AdultAuthConsentView {
    private func addViewSubComponents() {
        [consentButton, warningView].forEach { addArrangedSubview($0) }
    }
    
    private func makeConsentButtonConstraints() {
        consentButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(AdultAuthConsentButtonNameSpace.height)
        }
    }
    
    private func makeWarningViewConstraints() {
        warningView.snp.makeConstraints {
            $0.height.equalTo(AdultAuthWarningViewNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthConsentView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthConsentView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthConsentViewNameSpace.warringViewShowHeight,
                   alignment: .center)
    }
    
    struct AdultAuthConsentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthConsentView()
            v.consentButton.isConsented.accept(false)
            v.isWarningViewHidden.accept(false)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
