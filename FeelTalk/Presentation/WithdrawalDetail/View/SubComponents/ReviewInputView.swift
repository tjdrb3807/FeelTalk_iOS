//
//  ReviewInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewInputView: UIStackView {
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ReviewInputViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = ReviewInputViewNameSpace.headerLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ReviewInputViewNameSpace.headerLabelTextSize)
        label.setLineHeight(height: ReviewInputViewNameSpace.headerLabelLineHeight)
        
        return label
    }()
    
    private lazy var reviewInputTextView: CustomTextView = { CustomTextView(
        placeholder: ReviewInputViewNameSpace.reviewInputTextViewPlaceholder,
        maxTextCout: ReviewInputViewNameSpace.reviewInputTextViewMaxCount)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ReviewInputViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeReviewInputTextViewConstraints()
    }
}

extension ReviewInputView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [headerLabel, reviewInputTextView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeReviewInputTextViewConstraints() {
        reviewInputTextView.snp.makeConstraints { $0.height.equalTo(ReviewInputViewNameSpace.reviewInputTextViewHeight) }
    }
}

#if DEBUG

import SwiftUI

struct ReviewInputView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ReviewInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ReviewInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ReviewInputView()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
