//
//  SignalOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalOpenGraph: UIView {
    let model = PublishRelay<SignalType>()
    private let disposeBag = DisposeBag()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = SignalOpenGraphNameSpace.totalStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = SignalOpenGraphNameSpace.titleLabelText
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: SignalOpenGraphNameSpace.titleLabelTextSize)
        label.setLineHeight(height: SignalOpenGraphNameSpace.titleLabelLineHeight)
        label.numberOfLines = SignalOpenGraphNameSpace.titleLabelNumberOfLines
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SignalOpenGraphNameSpace.contentViewCornerRadius
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = SignalOpenGraphNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var signalImageView: UIImageView = { UIImageView() }()
    
    private lazy var subContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = SignalOpenGraphNameSpace.subContentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SignalOpenGraphNameSpace.percentLabelTextSize)
        label.textAlignment = .center
        label.layer.borderWidth = SignalOpenGraphNameSpace.percentLabelBorderWidth
        label.layer.cornerRadius = SignalOpenGraphNameSpace.percentLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: SignalOpenGraphNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: SignalOpenGraphNameSpace.descriptionLAbelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, type in
                v.setSignalImageProperties(with: type)
                v.setPercentLabelProperties(with: type)
                v.setDescriptionLabelProperties(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = SignalOpenGraphNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTotalStackViewSubComponents()
        addContentViewSubComponents()
        addContentStackViewSubComponents()
        addSubContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeContentStackViewConstraints()
        makePercentLabelConstraints()
    }
}

extension SignalOpenGraph {
    private func addViewSubComponents() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalOpenGraphNameSpace.totalStackViewTopInset)
            $0.leading.equalToSuperview().inset(SignalOpenGraphNameSpace.totalStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(SignalOpenGraphNameSpace.totalStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(SignalOpenGraphNameSpace.totalStackViewBottomInset)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [titleLabel, contentView].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func addContentViewSubComponents() { contentView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalOpenGraphNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(SignalOpenGraphNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(SignalOpenGraphNameSpace.contentStackViewTrailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [signalImageView, subContentStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func addSubContentStackViewSubComponents() {
        [percentLabel, descriptionLabel].forEach { subContentStackView.addArrangedSubview($0) }
    }
    
    private func makePercentLabelConstraints() {
        percentLabel.snp.makeConstraints {
            $0.width.equalTo(SignalOpenGraphNameSpace.percentLabelWidth)
            $0.height.equalTo(SignalOpenGraphNameSpace.percentLabelHeight)
        }
    }
}

extension SignalOpenGraph {
    private func setSignalImageProperties(with tyep: SignalType) {
        switch tyep {
        case .sexy:
            signalImageView.rx.image.onNext(UIImage(named: "image_signal_middle_sexy"))
        case .love:
            signalImageView.rx.image.onNext(UIImage(named: "image_signal_middle_love"))
        case .ambiguous:
            signalImageView.rx.image.onNext(UIImage(named: "image_signal_middle_ambiguous"))
        case .refuse:
            signalImageView.rx.image.onNext(UIImage(named: "image_signal_middle_refuse"))
        case .tired:
            signalImageView.rx.image.onNext(UIImage(named: "image_signal_middle_tired"))
        }
    }
    
    private func setPercentLabelProperties(with type: SignalType) {
        switch type {
        case .sexy:
            percentLabel.rx.text.onNext("100%")
            percentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal100))
            percentLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal100)?.cgColor)
        case .love:
            percentLabel.rx.text.onNext("75%")
            percentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal075))
            percentLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal075)?.cgColor)
        case .ambiguous:
            percentLabel.rx.text.onNext("50%")
            percentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal050))
            percentLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal050)?.cgColor)
        case .refuse:
            percentLabel.rx.text.onNext("25%")
            percentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal025))
            percentLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal025)?.cgColor)
        case .tired:
            percentLabel.rx.text.onNext("0%")
            percentLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.signal000))
            percentLabel.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.signal000)?.cgColor)
        }
    }
    
    private func setDescriptionLabelProperties(with type: SignalType) {
        switch type {
        case .sexy:
            descriptionLabel.rx.text.onNext("나 오늘 준비됐어 !")
        case .love:
            descriptionLabel.rx.text.onNext("오늘 사랑 충만 !")
        case .ambiguous:
            descriptionLabel.rx.text.onNext("나도 날 잘 모르겠어")
        case .refuse:
            descriptionLabel.rx.text.onNext("그럴 기분 아니야 !")
        case .tired:
            descriptionLabel.rx.text.onNext("오늘은 정말 피곤해..")
        }
    }
}

#if DEBUG

import SwiftUI

struct SignalOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        SignalOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: SignalOpenGraphNameSpace.width,
                   height: SignalOpenGraphNameSpace.height,
                   alignment: .center)
    }
    
    struct SignalOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignalOpenGraph()
            v.model.accept(.refuse)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

