//
//  SignalOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalOpenGraph: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = SignalOpenGraphNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = SignalOpenGraphNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: SignalOpenGraphNameSpace.titleLabelTextSize)
        label.numberOfLines = SignalOpenGraphNameSpace.titleLabelNumberOfLines
        label.setLineHeight(height: SignalOpenGraphNameSpace.titleLabelLineHeight)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var signalImage: UIImageView = { UIImageView() }()
    
    private lazy var signalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: SignalOpenGraphNameSpace.signalLabelTextSize)
        label.setLineHeight(height: SignalOpenGraphNameSpace.signalLabelLineHeight)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    init(type: SignalType) {
        super.init(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: SignalOpenGraphNameSpace.width,
                height: SignalOpenGraphNameSpace.height)))
        
        self.setUpView(with: type)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = SignalOpenGraphNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStakcViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
    }
}

extension SignalOpenGraph {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStakcViewSubComponents() {
        [titleLabel, signalImage, signalLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension SignalOpenGraph {
    private func setUpView(with type: SignalType) {
        switch type {
        case .sexy:
            signalImage.image = UIImage(named: SignalOpenGraphNameSpace.signalImageSexyType)
            signalLabel.text = SignalOpenGraphNameSpace.signalLabelSexyTypeText
        case .love:
            signalImage.image = UIImage(named: SignalOpenGraphNameSpace.signalImageLoveType)
            signalLabel.text = SignalOpenGraphNameSpace.signalLabelLoveTypeText
        case .ambiguous:
            signalImage.image = UIImage(named: SignalOpenGraphNameSpace.signalImageAmbiguousType)
            signalLabel.text = SignalOpenGraphNameSpace.signalLabelAmbiguousTypeText
        case .refuse:
            signalImage.image = UIImage(named: SignalOpenGraphNameSpace.signalImageRefuseType)
            signalLabel.text = SignalOpenGraphNameSpace.signalLabelRefuseTypeText
        case .tired:
            signalImage.image = UIImage(named: SignalOpenGraphNameSpace.signalImageTiredType)
            signalLabel.text = SignalOpenGraphNameSpace.signalLabelTiredTypeText
        }
    }
}
    
#if DEBUG
    
    import SwiftUI
    
    struct SignalOpenGraph_Previews: PreviewProvider {
        static var previews: some View {
            SignalOpenGraph_Presentable()
                .edgesIgnoringSafeArea(.all)
                .frame(
                    width: SignalOpenGraphNameSpace.width,
                    height: SignalOpenGraphNameSpace.height,
                    alignment: .center)
        }
        
        struct SignalOpenGraph_Presentable: UIViewRepresentable {
            func makeUIView(context: Context) -> some UIView {
                SignalOpenGraph(type: .sexy)
            }
            
            func updateUIView(_ uiView: UIViewType, context: Context) {}
        }
    }
    
#endif
