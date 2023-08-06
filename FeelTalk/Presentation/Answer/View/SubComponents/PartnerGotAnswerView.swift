//
//  PartnerGotAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit
import SnapKit

final class PartnerGotAnswerView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerGotAnswerViewNameSpace.titleLabelText
        label.textColor = UIColor(named: PartnerGotAnswerViewNameSpace.titleLabelTextColor)
        label.font = UIFont(name: PartnerGotAnswerViewNameSpace.titleLabelTextFont,
                            size: PartnerGotAnswerViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.backgroundColor = UIColor(named: PartnerGotAnswerViewNameSpace.backgroundColor)
        self.layer.cornerRadius = PartnerGotAnswerViewNameSpace.cornerRadius
    }
    
    private func addSubComponents() {
        addSubview(titleLabel)
    }
    
    private func setConfigurations() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerGotAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerGotAnswerView_Presentable()
    }
    
    struct PartnerGotAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PartnerGotAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
