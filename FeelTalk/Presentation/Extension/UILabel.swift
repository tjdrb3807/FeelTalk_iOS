//
//  UILabel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//
import UIKit

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
    
    func setLineHeight(height: CGFloat) {
        guard let text = text else { return }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = height
        style.minimumLineHeight = height
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (height - font.lineHeight) / 2
        ]
        let attributeString = NSAttributedString(string: text, attributes: attributes)
        
        attributedText = attributeString
    }
    
    func asColor(targetStringList: [String], color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.foregroundColor: color as Any], range: range)
            
            attributedText = attributedString
        }
    }
    
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
}
