//
//  PartnerNoAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit
import SnapKit

final class PartnerNoAnswerView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerNoAnswerViewNameSpace.titleLabelText
        label.textColor = UIColor(named: PartnerNoAnswerViewNameSpace.titleLabelTextColor)
        label.textAlignment = .center
        label.font = UIFont(name: PartnerNoAnswerViewNameSpace.titleLabelTextFont,
                            size: PartnerNoAnswerViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    private lazy var answerChaseUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(PartnerNoAnswerViewNameSpace.answerChaseUpButtonTitleText,
                        for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: PartnerNoAnswerViewNameSpace.answerChaseUpButtonTitleTextFont,
                                         size: PartnerNoAnswerViewNameSpace.answerChaseUpButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = PartnerNoAnswerViewNameSpace.answerCuaseUpButtonCornerRadius
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.backgroundColor = UIColor(named: PartnerNoAnswerViewNameSpace.backgroundColor)
        self.layer.cornerRadius = PartnerNoAnswerViewNameSpace.cornerRadius
    }
    
    private func addSubComponents() {
        [titleLabel, answerChaseUpButton].forEach { addSubview($0) }
    }
    
    private func setConfigurations() {
        makeTitleLabelConstraints()
        makeAnswerChaseUpButtonConstraints()
    }
}

extension PartnerNoAnswerView {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(PartnerNoAnswerViewNameSpace.titleLabelTopInset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(PartnerNoAnswerViewNameSpace.titleLabelHeight)
        }
    }
    
    private func makeAnswerChaseUpButtonConstraints() {
        answerChaseUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(PartnerNoAnswerViewNameSpace.answerChaseUpButtonBottomInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(PartnerNoAnswerViewNameSpace.answerChaseUpButtonWidth)
            $0.height.equalTo(PartnerNoAnswerViewNameSpace.answerChaseUpButotnHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerNoAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNoAnswerView_Presentable()
    }
    
    struct PartnerNoAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PartnerNoAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
