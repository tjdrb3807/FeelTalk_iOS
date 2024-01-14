//
//  SignalPercentageView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalPercentageView: UIStackView {
    let model = PublishRelay<Signal>()
    private let disposeBag = DisposeBag()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SignalPercentageViewNameSpace.percentageLabelTextSize)
        
        label.layer.borderWidth = SignalPercentageViewNameSpace.percentableLabelBorderWidth
        label.layer.cornerRadius = SignalPercentageViewNameSpace.percentageLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: SignalPercentageViewNameSpace.descriptionLabelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .map { $0.type }
            .withUnretained(self)
            .bind { v, type in
                v.setPercentageLabelProperties(with: type)
                v.setDescriptionLabelProperties(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = SignalPercentageViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    private func addSubComponents() {
        [percentageLabel, descriptionLabel].forEach { addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        makePercentageLabelConstraints()
        makeDescriptionLabelConstraints()
    }
}

extension SignalPercentageView {
    private func setPercentageLabelProperties(with model: SignalType) {
        switch model {
        case .sexy:
            percentageLabel.rx.text.onNext(SignalPercentageViewNameSpace.percentageLabelSexyTypeText)
            percentageLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal100))
            percentageLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal100)?.cgColor)
        case .love:
            percentageLabel.rx.text.onNext(SignalPercentageViewNameSpace.percentageLabelLoveTypeText)
            percentageLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal075))
            percentageLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal075)?.cgColor)
        case .ambiguous:
            percentageLabel.rx.text.onNext(SignalPercentageViewNameSpace.percentageLabelAmbiguousTypeText)
            percentageLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal050))
            percentageLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal050)?.cgColor)
        case .refuse:
            percentageLabel.rx.text.onNext(SignalPercentageViewNameSpace.percentageLabelRefuseTypeText)
            percentageLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal025))
            percentageLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal025)?.cgColor)
        case .tired:
            percentageLabel.rx.text.onNext(SignalPercentageViewNameSpace.percentageLabelTiredTypeText)
            percentageLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal000))
            percentageLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal000)?.cgColor)
        }
    }
    
    private func setDescriptionLabelProperties(with model: SignalType) {
        switch model {
        case .sexy:
            descriptionLabel.rx.text.onNext(SignalPercentageViewNameSpace.descriptionLabelSexyTypeText)
        case .love:
            descriptionLabel.rx.text.onNext(SignalPercentageViewNameSpace.descriptionLabelLoveTypeText)
        case .ambiguous:
            descriptionLabel.rx.text.onNext(SignalPercentageViewNameSpace.descriptionLabelAmbiguousTypeText)
        case .refuse:
            descriptionLabel.rx.text.onNext(SignalPercentageViewNameSpace.descriptionLabelRefuseTypeText)
        case .tired:
            descriptionLabel.rx.text.onNext(SignalPercentageViewNameSpace.descriptionLabelTiredTypeText)
        }
    }
}

extension SignalPercentageView {
    private func makePercentageLabelConstraints() {
        percentageLabel.snp.makeConstraints {
            $0.width.equalTo(SignalPercentageViewNameSpace.percentableLabelWidth)
            $0.height.equalTo(SignalPercentageViewNameSpace.percentageLabelHeight)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct SignalPercentageView_Previews: PreviewProvider {
    static var previews: some View {
        SignalPercentageView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: SignalPercentageViewNameSpace.height,
                   alignment: .center)
    }
    
    struct SignalPercentageView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignalPercentageView()
            v.model.accept(Signal(type: .love))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
