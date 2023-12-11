//
//  TextChatView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct TextChatModel {
    let text: String
    let isMine: Bool
}

final class TextChatView: UITextView {
    let model = PublishRelay<TextChatModel>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setProperties()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, data in
                v.setLineAndLetterSpacing(data.text)
                v.rx.text.onNext(data.text)
                v.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular,
                                        size: CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26))
                v.setBackgroundColor(data.isMine)
                v.setTextColor(data.isMine)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        layer.cornerRadius = 16.0
        textContainerInset = .init(top: CommonConstraintNameSpace.verticalRatioCalculator * 1.23,
                                   left: CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26,
                                   bottom: CommonConstraintNameSpace.verticalRatioCalculator * 1.23,
                                   right: CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26)
        textContainer.lineBreakMode = .byWordWrapping
        isEditable = false
        clipsToBounds = true
    }
}

extension TextChatView {
    private func setBackgroundColor(_ mode: Bool) {
        mode ?
        rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
        rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray100))
    }
    
    private func setTextColor(_ mode: Bool) {
        mode ?
        rx.textColor.onNext(.white) :
        rx.textColor.onNext(.black)
    }
}

#if DEBUG

import SwiftUI

struct TextChatView_Previews: PreviewProvider {
    static var previews: some View {
        TextChatView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: CommonConstraintNameSpace.horizontalRatioCalculaotr * 69.33,
                   height: CommonConstraintNameSpace.verticalRatioCalculator * 14.28,
                   alignment: .center)
    }
    
    struct TextChatView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = TextChatView()
            v.model.accept(TextChatModel(text: "grapes vanilla carnival florence marshmallow cresent serendipity flutter like laptop way bijou lovable charming.",
                                         isMine: true))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif


