//
//  QuestionInputViewAnswerSuccessButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/13.
//

import UIKit

final class QuestionInputViewAnswerSuccessButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        setTitle("답변완료", for: .normal)
        titleLabel?.font = UIFont(name: "pretendard-medium", size: 18.0)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor(named: "main_400")
        layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 7.26) / 2
        isEnabled = false
    }
}

#if DEBUG

import SwiftUI

struct QuestionInputViewAnswerSuccessButton_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputViewAnswerSuccessButton_Presentable()
    }
    
    struct QuestionInputViewAnswerSuccessButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionInputViewAnswerSuccessButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
