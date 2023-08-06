//
//  QuestionTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import SnapKit

final class QuestionTitleView: UIStackView {
    private lazy var questionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTitleViewNameSpace.headerLabelText
        label.textColor = .black
        label.font = UIFont(name: QuestionTitleViewNameSpace.labelTextFont,
                            size: QuestionTitleViewNameSpace.labelTextSize)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var questionBodyLabel: UILabel = {
        let label = UILabel()
        label.text = QuestionTitleViewNameSpace.bodyLabelText
        label.textColor = .black
        label.font = UIFont(name: QuestionTitleViewNameSpace.labelTextFont,
                            size: QuestionTitleViewNameSpace.labelTextSize)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fillEqually
        self.isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [questionHeaderLabel, questionBodyLabel].forEach { addArrangedSubview($0) }
    }
}

extension QuestionTitleView {
    func getHighlightTextList(to title: String, with highlight: [Int]) -> [String] {
        var text: String = ""
        var currendIndex: Int = highlight[0]
        var previousIndex: Int = highlight[0]
        var textList: [String] = []
        
        highlight.forEach { index in
            let stringIndex = title.index(title.startIndex, offsetBy: index)
            let char: Character = title[stringIndex]
            
            currendIndex = index
            
            if (previousIndex - currendIndex) < -1 {
                textList.append(text)
                text.removeAll()
            }
            
            text.append(char)
            previousIndex = index
        }
        
        textList.append(text)
        
        return textList
    }
    
    func setDate(title: String, header: String, body: String, highlight: [Int]) {
        self.questionHeaderLabel.text = header
        self.questionBodyLabel.text = body
        
        if !highlight.isEmpty {
            let highlightTextList = self.getHighlightTextList(to: title, with: highlight)
            self.questionBodyLabel.asColor(targetStringList: highlightTextList, color: UIColor(named: QuestionTitleViewNameSpace.bodyLabelHighlightColor))
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTitleView_Presentable()
    }
    
    struct QuestionTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionTitleView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
