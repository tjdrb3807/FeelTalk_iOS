//
//  WithdrawalDetailDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/31.
//

import UIKit
import SnapKit

final class WithdrawalDetailDescriptionView: UIView {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = WithdrawalDetailDescriptionViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: WithdrawalDetailDescriptionViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = WithdrawalDetailDescriptionViewNameSpace.descriptionLabelNumberOfLines
        label.setLineHeight(height: WithdrawalDetailDescriptionViewNameSpace.descriptionLabelLineHeight)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: WithdrawalDetailDescriptionViewNameSpace.height)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.2]
        gradientLayer.position = center

        self.layer.addSublayer(gradientLayer)
    }
    
    private func addSubComponents() { addSubview(descriptionLabel) }
    
    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalDetailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetailDescriptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: WithdrawalDetailDescriptionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct WithdrawalDetailDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            WithdrawalDetailDescriptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
