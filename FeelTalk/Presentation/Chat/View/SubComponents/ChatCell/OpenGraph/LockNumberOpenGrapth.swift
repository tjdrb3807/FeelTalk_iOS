//
//  LockNumberOpenGrapth.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberOpenGraph: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberOpenGraphNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var sosImage: UIImageView = {
        UIImageView(image: UIImage(named: LockNumberOpenGraphNameSpace.sosImage))
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberOpenGraphNameSpace.labelStackViewSpacing
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberOpenGraphNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: LockNumberOpenGraphNameSpace.titleLabelTextSize)
        label.setLineHeight(height: LockNumberOpenGraphNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberOpenGraphNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberOpenGraphNameSpace.descriptionLabelTextSize)
        label.numberOfLines = LockNumberOpenGraphNameSpace.descriptionLabelNumberOfLines
        label.setLineHeight(height: LockNumberOpenGraphNameSpace.descriptionLabelLineHeight)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var warningContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberOpenGraphNameSpace.warningContentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var warningIcon: UIImageView = {
        UIImageView(image: UIImage(named: LockNumberOpenGraphNameSpace.warningIconImage))
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberOpenGraphNameSpace.warningLabelText
        label.textColor = .red
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberOpenGraphNameSpace.warningLabelTextSize)
        label.setLineHeight(height: LockNumberOpenGraphNameSpace.warningLabelLineHeight)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var helpButton: UIButton = {
        let button = UIButton()
        button.setTitle(LockNumberOpenGraphNameSpace.helpButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: LockNumberOpenGraphNameSpace.helpButtonTitleTextSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = LockNumberOpenGraphNameSpace.helpButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: LockNumberOpenGraphNameSpace.width,
                height: LockNumberOpenGraphNameSpace.height)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = LockNumberOpenGraphNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addLabelStackViewSubComponents()
        addWarningContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeSOSImageConstraints()
        makeWarningIconConstraints()
        makeHelpButtonConstraints()
    }
}

extension LockNumberOpenGraph {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [sosImage, labelStackView, helpButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeSOSImageConstraints() {
        sosImage.snp.makeConstraints {
            $0.width.equalTo(LockNumberOpenGraphNameSpace.sosImageWidth)
            $0.height.equalTo(LockNumberOpenGraphNameSpace.sosImageHeight)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, descriptionLabel, warningContentStackView].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func addWarningContentStackViewSubComponents() {
        [warningIcon, warningLabel].forEach { warningContentStackView.addArrangedSubview($0) }
    }
    
    private func makeWarningIconConstraints() {
        warningIcon.snp.makeConstraints {
            $0.width.equalTo(LockNumberOpenGraphNameSpace.warningIconWidth)
            $0.height.equalTo(LockNumberOpenGraphNameSpace.warningIconHeight)
        }
    }
    
    private func makeHelpButtonConstraints() {
        helpButton.snp.makeConstraints {
            $0.width.equalTo(LockNumberOpenGraphNameSpace.helpButtonWidth)
            $0.height.equalTo(LockNumberOpenGraphNameSpace.helpButtonHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: LockNumberOpenGraphNameSpace.width,
                height: LockNumberOpenGraphNameSpace.height,
                alignment: .center)
    }
    
    struct LockNumberOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockNumberOpenGraph()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
