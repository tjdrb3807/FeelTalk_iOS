//
//  SuggestionsIdeaInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import UIKit
import SnapKit

final class SuggestionsIdeaInputView: UIStackView {
    private lazy var titleView: CustomTitleView = { CustomTitleView(type: .questionIdeas) }()
    
    lazy var ideaInputTextView: CustomTextView = {
        let customTextView = CustomTextView(placeholder: SuggestionsIdeaInputViewNameSpace.ideaInputTextViewPlaceholder,
                                            maxTextCout: SuggestionsIdeaInputViewNameSpace.ideaInputTextViewMaxTextCount)
        customTextView.textView.inputAccessoryView = ideaInputTextViewAccessoryView
        
        return customTextView
    }()
    
    lazy var ideaInputTextViewAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = SuggestionsIdeaInputViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        [titleView, ideaInputTextView].forEach { addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        makeTitleViewConstraints()
        makeIdeaInputTextViewConstraints()
    }
}

extension SuggestionsIdeaInputView {
    private func makeTitleViewConstraints() {
        titleView.snp.makeConstraints { $0.height.equalTo(CustomTitleViewNameSpace.height) }
    }
    
    private func makeIdeaInputTextViewConstraints() {
        ideaInputTextView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(SuggestionsIdeaInputViewNameSpace.ideaInputTextViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct SuggestionsIdeaInputView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsIdeaInputView_Presentable()
    }
    
    struct SuggestionsIdeaInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SuggestionsIdeaInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
