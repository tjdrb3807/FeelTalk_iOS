//
//  ServiceTerminationStatementTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationStatementTitleView: UIStackView {
    let type = PublishRelay<TerminationType>()
    private let disposeBag = DisposeBag()
    
    private lazy var warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ServiceTerminationStateTitleViewNameSpace.warningImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var titleMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ServiceTerminationStateTitleViewNameSpace.titleMessageLabelTextSize)
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
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
                v.setData(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = ServiceTerminationStateTitleViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() { [warningImageView, titleMessageLabel].forEach { addArrangedSubview($0) } }
    
    private func setConstraints() {
        warningImageView.snp.makeConstraints {
            $0.width.equalTo(ServiceTerminationStateTitleViewNameSpace.warningImageViewWidth)
            $0.height.equalTo(warningImageView.snp.width)
        }
        
        
    }
}

extension ServiceTerminationStatementTitleView {
    private func setData(with type: TerminationType) {
        switch type {
        case .breakUp:
            titleMessageLabel.rx.text.onNext(ServiceTerminationStateTitleViewNameSpace.titleMessageLabelBreakUpTypeText)
        case .withdrawal:
            titleMessageLabel.rx.text.onNext(ServiceTerminationStateTitleViewNameSpace.titleMessageLabelWithdrawalTypeText)
        }
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationStatementTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationStatementTitleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 100,
                   alignment: .center)
    }
    
    struct ServiceTerminationStatementTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationStatementTitleView()
            view.type.accept(.breakUp)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
