//
//  ServiceTerminationStatementInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationStatementInfoView: UIView {
    let type = PublishRelay<TerminationType>()
    private let disposeBag = DisposeBag()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = ServiceTerminationStatementInfoViewNameSpace.infoStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        type
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, type in
                v.setData(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = ServiceTerminationStatementInfoViewNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addSubview(infoStackView)
    }
    
    private func setConstraints() {
        infoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ServiceTerminationStatementInfoViewNameSpace.infoStackViewTopInset)
            $0.leading.equalToSuperview().inset(ServiceTerminationStatementInfoViewNameSpace.infoStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(ServiceTerminationStatementInfoViewNameSpace.infoStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(ServiceTerminationStatementInfoViewNameSpace.infoStackViewBottomInset)
        }
    }
}

extension ServiceTerminationStatementInfoView {
    private func setData(with type: TerminationType) {
        switch type {
        case .breakUp:
            [ServiceTerminationStatementInfoCell(), ServiceTerminationStatementInfoCell(), ServiceTerminationStatementInfoCell()].forEach { infoStackView.addArrangedSubview($0) }
            let firstCell = infoStackView.subviews[ServiceTerminationStatementInfoViewNameSpace.infoStackViewFirstComponentsIndex] as! ServiceTerminationStatementInfoCell
            firstCell.type.accept(.breakUpRemoveData)
            
            let secondCell = infoStackView.subviews[ServiceTerminationStatementInfoViewNameSpace.infoStackViewSecondComponentsIndex] as! ServiceTerminationStatementInfoCell
            secondCell.type.accept(.breakUpRecoveryablePeriod)
            
            let thirdCell = infoStackView.subviews[ServiceTerminationStatementInfoViewNameSpace.infoStackViewThirdComponentsIndex] as! ServiceTerminationStatementInfoCell
            thirdCell.type.accept(.breakUpReconnect)
        
        case .withdrawal:
            [ServiceTerminationStatementInfoCell(), ServiceTerminationStatementInfoCell()].forEach { infoStackView.addArrangedSubview($0) }
            let firstCell = infoStackView.subviews[ServiceTerminationStatementInfoViewNameSpace.infoStackViewFirstComponentsIndex] as! ServiceTerminationStatementInfoCell
            firstCell.type.accept(.withdrawalRemoveData)
            
            let secondCell = infoStackView.subviews[ServiceTerminationStatementInfoViewNameSpace.infoStackViewSecondComponentsIndex] as! ServiceTerminationStatementInfoCell
            secondCell.type.accept(.withdrawalUnrecoverable)
        }
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationStatementInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationStatementInfoView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset + ServiceTerminationStatementInfoViewNameSpace.infoStackViewLeadingInset + ServiceTerminationStatementInfoViewNameSpace.infoStackViewTrailingInset),
                   height: CommonConstraintNameSpace.verticalRatioCalculator * 13.66,
                   alignment: .center)
    }
    
    struct ServiceTerminationStatementInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationStatementInfoView()
            view.type.accept(.breakUp)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
