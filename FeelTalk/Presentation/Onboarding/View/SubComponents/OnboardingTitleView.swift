//
//  OnboardingTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/31.
//

import UIKit
import SnapKit

final class OnboardingTitleView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CommonFontNameSpace.payboocBold,
                            size: OnboardingTitleViewNameSpace.titleLabelTextSize)
        label.textColor = .black
        label.numberOfLines = OnboardingTitleViewNameSpace.titleLabelNumberOfLines
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: OnboardingTitleViewNameSpace.descriptionLabelTextSize)
        label.textColor = .black
        label.numberOfLines = OnboardingTitleViewNameSpace.descriptionLabelNumberOfLines
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        self.setProperties()
        self.addSubComponents()

        self.descriptionLabel.setLineHeight(height: OnboardingTitleViewNameSpace.descriptionLabelLineHeight)
        self.descriptionLabel.textAlignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = OnboardingTitleViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() { addViewSubComponents() }
}

extension OnboardingTitleView {
    private func addViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct OnboardingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: OnboardingTitleViewNameSpace.height,
                   alignment: .center)
    }
    
    struct OnboardingTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            OnboardingTitleView(title: "오늘 내 상태는 말이야",
                                description: """
                                             귀여운 필롱이로 연인에게
                                             오늘의 시그널을 보낼 수 있어요!
                                             """)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
