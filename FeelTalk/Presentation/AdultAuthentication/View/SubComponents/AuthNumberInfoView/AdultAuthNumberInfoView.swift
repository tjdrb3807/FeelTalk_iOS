//
//  AdultAuthNumberInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthNumberInfoView: UIStackView {
    let descriptionState = PublishRelay<AdultAuthNumberDescription>()
    let expiradTime = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    lazy var numberInputView: AdultAuthNumberInputView = { AdultAuthNumberInputView() }()
    
    private lazy var descriptionView: AdultAuthNumberDesciptionView = { AdultAuthNumberDesciptionView() }()
    
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
    
    private func bind() {
        descriptionState
            .bind(to: descriptionView.descriptionState)
            .disposed(by: disposeBag)
        
        expiradTime
            .bind(to: descriptionView.expiradTime)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = AdultAuthNumberInfoViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeNumberInputViewConstraints()
    }
}

extension AdultAuthNumberInfoView {
    private func addViewSubComponents() { [numberInputView, descriptionView].forEach { addArrangedSubview($0) } }
    
    private func makeNumberInputViewConstraints() {
        numberInputView.snp.makeConstraints { $0.height.equalTo(AdultAuthNumberInputViewNameSpace.height) }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthNumberInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthNumberInfoView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthNumberInfoViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthNumberInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthNumberInfoView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
