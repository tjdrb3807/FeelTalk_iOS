//
//  CustomTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import UIKit
import SnapKit

final class CustomTitleView: UIStackView {
    var type: TitleType

    private lazy var leadingSpacingView: UIView = { UIView() }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: CustomTitleViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: CustomTitleViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var essentialMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: CustomTitleViewNameSpace.essentialMarkImageViewImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    init(type: TitleType) {
        self.type = type
        super.init(frame: .zero)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = CustomTitleViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        [leadingSpacingView, titleLabel, essentialMarkImageView].forEach { addArrangedSubview($0) }
    }
    
    private func setConstratins() {
        makeLeadingSpacingViewConstraints()
        makeTitleLabelConstraints()
        makeEssentialMarkImageViewConstratins()
    }
}

extension CustomTitleView {
    private func makeLeadingSpacingViewConstraints() {
        leadingSpacingView.snp.makeConstraints { $0.width.equalTo(CustomTitleViewNameSpace.leadingSpacingViewWidth) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.width.equalTo(titleLabel.intrinsicContentSize)}
    }
    
    private func makeEssentialMarkImageViewConstratins() {
        essentialMarkImageView.snp.makeConstraints {
            $0.width.equalTo(CustomTitleViewNameSpace.essentialMarkImageViewWidth)
            $0.height.equalTo(CustomTitleViewNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTitleView_Presentable()
    }
    
    struct CustomTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTitleView(type: .inquiryInfo)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
