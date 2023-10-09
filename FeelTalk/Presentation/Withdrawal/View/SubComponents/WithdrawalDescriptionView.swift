//
//  WithdrawalDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/21.
//

import UIKit
import RxSwift

final class WithdrawalDescriptionView: UIStackView {
    private lazy var firstLineLabel: UILabel = {
        let label = UILabel()
        label.text = WithdrawalDescriptionViewNameSpace.firstLineLabelText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: WithdrawalDescriptionViewNameSpace.labelCommonTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: WithdrawalDescriptionViewNameSpace.labelCommonLineHeight)
        return label
    }()
    
    private lazy var secondLineLabel: UILabel = {
        let label = UILabel()
        label.text = WithdrawalDescriptionViewNameSpace.secondLineLabelText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: WithdrawalDescriptionViewNameSpace.labelCommonTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: WithdrawalDescriptionViewNameSpace.labelCommonLineHeight)
        
        return label
    }()
    
    private lazy var thirdLineLabel: UILabel = {
        let label = UILabel()
        label.text = WithdrawalDescriptionViewNameSpace.thirdLineLableText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: WithdrawalDescriptionViewNameSpace.labelCommonTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: WithdrawalDescriptionViewNameSpace.labelCommonLineHeight)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillEqually
        spacing = WithdrawalDescriptionViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        [firstLineLabel, secondLineLabel, thirdLineLabel].forEach { addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDescriptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: WithdrawalDescriptionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct WithdrawalDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            WithdrawalDescriptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
