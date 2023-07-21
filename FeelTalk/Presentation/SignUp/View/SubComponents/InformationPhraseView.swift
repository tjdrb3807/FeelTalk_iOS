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
        label.text = SignUpNameSpace.informationLabelText
        label.textColor = .black
        label.font = UIFont(name: SignUpNameSpace.informationLableTextFont, size: SignUpNameSpace.informationLabelTextSize)
        label.backgroundColor = .clear
        label.numberOfLines = SignUpNameSpace.informationLabelNumberOfLines
        label.setLineSpacing(spacing: SignUpNameSpace.informationLabelLineSpacing)
        
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
        addSubview(informationLabel)
    }
    
    private func setConfiguration() {
        informationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignUpNameSpace.informationLabelTopInset)
            $0.leading.equalToSuperview().inset(SignUpNameSpace.informationLabelLeadingInset)
        }
    }
}

extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
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
