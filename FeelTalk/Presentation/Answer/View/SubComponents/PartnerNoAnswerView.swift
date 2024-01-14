//
//  PartnerNoAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit
import SnapKit

final class PartnerNoAnswerView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = PartnerNoAnswerViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerNoAnswerViewNameSpace.titleLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: PartnerNoAnswerViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    lazy var pressForAnswerButton: UIButton = {
        let button = UIButton()
        button.setTitle(PartnerNoAnswerViewNameSpace.answerChaseUpButtonTitleText,
                        for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: PartnerNoAnswerViewNameSpace.answerChaseUpButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = PartnerNoAnswerViewNameSpace.answerCuaseUpButtonCornerRadius
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.setProperties()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        self.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        self.layer.cornerRadius = PartnerNoAnswerViewNameSpace.cornerRadius
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStakcViewSubComponents()
    }
    
    private func setConfigurations() {
        makeContentStackViewConstraints()
        makeTitleLabelConstraints()
        makePressForAnswerButtonConstraints()
    }
}

extension PartnerNoAnswerView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStakcViewSubComponents() {
        [titleLabel, pressForAnswerButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(PartnerNoAnswerViewNameSpace.titleLabelHeight)
        }
    }
    
    private func makePressForAnswerButtonConstraints() {
        pressForAnswerButton.snp.makeConstraints {
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
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: PartnerNoAnswerViewNameSpace.height,
                   alignment: .center)
    }
    
    struct PartnerNoAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PartnerNoAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
