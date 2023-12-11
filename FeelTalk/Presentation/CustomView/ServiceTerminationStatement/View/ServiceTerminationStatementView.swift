//
//  ServiceTerminationStatementView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationStatementView: UIView {
    let type = PublishRelay<TerminationType>()
    let isConfirmButtonCheked = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    fileprivate lazy var titleView: ServiceTerminationStatementTitleView = { ServiceTerminationStatementTitleView() }()
    
    fileprivate lazy var infoView: ServiceTerminationStatementInfoView = { ServiceTerminationStatementInfoView() }()
    
    fileprivate lazy var confirmButton: ServiceTerminationStatementConfirmButton = { ServiceTerminationStatementConfirmButton() }()
    
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
        
        confirmButton.isCheck
            .withUnretained(self)
            .bind { v, state in
                v.isConfirmButtonCheked.accept(state)
            }.disposed(by: disposeBag)
        
        type
            .withUnretained(self)
            .bind { v, type in
                v.titleView.type.accept(type)
                v.infoView.type.accept(type)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstratins() {
        makeTitleStackViewConstraints()
        makeInfoViewConstraints()
        makeConfirmButtonConstraints()
    }
}

extension ServiceTerminationStatementView {
    private func addViewSubComponents() { [titleView, infoView, confirmButton].forEach { addSubview($0) } }
    
    private func makeTitleStackViewConstraints() { titleView.snp.makeConstraints { $0.top.leading.equalToSuperview() } }
    
    private func makeInfoViewConstraints() {
        infoView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(ServiceTerminationStatementInfoViewNameSpace.topOffset)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ServiceTerminatinoStatementConfirmButtonNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationStatementView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationStatementView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 300,
                   alignment: .center)
    }
    
    struct ServiceTerminationStatementView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationStatementView()
            view.titleView.type.accept(.breakUp)
            view.infoView.type.accept(.breakUp)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
