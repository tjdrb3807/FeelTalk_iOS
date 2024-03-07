//
//  CustomInputViewTitle.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/08.
//

import UIKit
import SnapKit

final class CustomInputViewTitle: UIStackView {
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var titleLabel: UILabel = { UILabel() }()
    
    private lazy var asteriskIcon: UIImageView = { UIImageView(image: UIImage(named: CustomInputViewTitleNameSpace.asteriskIconImage)) }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    init(type: CustomInputTitleType, isRequiredInput: Bool) {
        super.init(frame: .zero)
        
        titleLabel.text = type.rawValue
        
        self.setProperties(with: type)
        self.addSubComponents(with: isRequiredInput)
        self.setConstraints(with: isRequiredInput)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties(with type: CustomInputTitleType) {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = CustomInputViewTitleNameSpace.spacing
        backgroundColor = .clear
        
        setupTitleLabelProperties(with: type)
    }
    
    private func addSubComponents(with isRequiredInput: Bool) {
        [leadingSpacing, titleLabel].forEach { addArrangedSubview($0) }
        
        if isRequiredInput { addArrangedSubview(asteriskIcon) }
        
        addArrangedSubview(trailingSpacing)
    }
    
    private func setConstraints(with isRequiredInput: Bool) {
        makeSpacingViewConstratins()
        makeTitleLabelConstraints()
        
        if isRequiredInput { makeAsteriskIconConstraints() }
    }
}

extension CustomInputViewTitle {
    private func makeSpacingViewConstratins() {
        [leadingSpacing, trailingSpacing].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(CustomInputViewTitleNameSpace.spacingViewWidth)
                $0.height.equalToSuperview()
            }
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
    }
    
    private func makeAsteriskIconConstraints() {
        asteriskIcon.snp.makeConstraints {
            $0.width.equalTo(CustomInputViewTitleNameSpace.asteriskIconWidth)
        }
    }
}

extension CustomInputViewTitle {
    private func setupTitleLabelProperties(with type: CustomInputTitleType) {
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        switch type {
        case .inquiryInfo:
            break
        case .receiveEmail:
            break
        case .questionIdeas:
            break
        case .email:
            break
        case .withdrawalReason:
            break
        case .myAnswer, .partnerAnswer,
                .challengeTitle, .challnegeContent, .challengeDeadline, .lockNumberHint:
            titleLabel.textColor = UIColor(named: CommonColorNameSpace.gray600)
            titleLabel.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                                     size: CustomInputViewTitleNameSpace.titleLabelTextSize12)
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomInputViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputViewTitle_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct CustomInputViewTitle_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomInputViewTitle(type: .challengeTitle, isRequiredInput: false)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
