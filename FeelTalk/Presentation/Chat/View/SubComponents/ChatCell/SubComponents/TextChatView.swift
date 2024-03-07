//
//  TextChatView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TextChatView: UITextView {
    init(isMine: Bool, message: String) {
        super.init(frame: .zero, textContainer: .none)
        
        text = message
        setProperties(with: isMine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties(with isMine: Bool) {
        let style = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString(string: text)
        style.lineSpacing = 3.0

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
        
        if isMine {
            textColor = .white
            backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        } else {
            textColor = .black
            backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        }
        
        font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 16.0)
        
        textContainerInset = UIEdgeInsets(
            top: 10.0,
            left: 16.0,
            bottom: 10.0,
            right: 16.0)
        
        layer.cornerRadius = 16.0
        isScrollEnabled = false
        isEditable = false
        
        
        sizeToFit() // 텍스트 길이에 맞에 사이즈 맞춤
    }
}

#if DEBUG

import SwiftUI

struct TextChatView_Previews: PreviewProvider {
    static var previews: some View {
        TextChatView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 0,
                height: 0,
                alignment: .center)
    }
    
    struct TextChatView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            TextChatView(isMine: false, message: "grapes vanilla carnival florence\nmarshmallow cresent\nserendipity flutter like laptop\nway bijou lovable charming.")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
