//
//  ServiceTerminationStatementInfoCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationStatementInfoCell: UIStackView {
    let type = PublishRelay<TerminationDescriptionType>()
    private let disposeBag = DisposeBag()
    
    private lazy var dot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray500)
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ServiceTerminationStatementInfoCellNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        type
            .withUnretained(self)
            .bind { v, type in
                v.descriptionLabel.rx.text.onNext(type.rawValue)
                v.descriptionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = ServiceTerminationStatementInfoCell.spacingUseSystem
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeDotConstraints()
    }
}

extension ServiceTerminationStatementInfoCell {
    private func addViewSubComponents() { [dot, descriptionLabel].forEach { addArrangedSubview($0) } }
    
    private func makeDotConstraints() {
        dot.snp.makeConstraints {
            $0.width.equalTo(ServiceTerminationStatementInfoCellNameSpace.dotWith)
            $0.height.equalTo(dot.snp.width)
        }
        
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(ServiceTerminationStatementInfoCellNameSpace.descriptionLabelHeight) }
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationStatementInfoCell_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationStatementInfoCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset + (CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4)),
                   height: ServiceTerminationStatementInfoCellNameSpace.descriptionLabelHeight,
                   alignment: .center)
    }
    
    struct ServiceTerminationStatementInfoCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationStatementInfoCell()
            view.type.accept(.breakUpReconnect)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
