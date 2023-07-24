//
//  InformationPhraseView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/12.
//

import UIKit
import SnapKit

final class InformationPhraseView: UIView {
    lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.text = SignUpViewNameSpace.informationLabelText
        label.textColor = .black
        label.font = UIFont(name: SignUpViewNameSpace.informationLableTextFont, size: SignUpViewNameSpace.informationLabelTextSize)
        label.backgroundColor = .clear
        label.numberOfLines = SignUpViewNameSpace.informationLabelNumberOfLines
        label.setLineSpacing(spacing: SignUpViewNameSpace.informationLabelLineSpacing)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubComponents() {
        backgroundColor = .yellow
        addSubview(informationLabel)
    }
    
    private func setConfiguration() {
        informationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignUpViewNameSpace.informationLabelTopInset)
            $0.leading.equalToSuperview().inset(SignUpViewNameSpace.informationLabelLeadingInset)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

#if DEBUG

import SwiftUI

struct InformationPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        InformationPhraseView_Presentable()
    }
    
    struct InformationPhraseView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InformationPhraseView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
#endif
