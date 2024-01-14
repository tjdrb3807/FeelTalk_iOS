//
//  QuestionTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionTitleView: UIView {
    let model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: QuestionTitleViewNameSpace.labelTextSize)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: QuestionTitleViewNameSpace.labelTextSize)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.headerLabel.rx.text.onNext(model.header)
                v.bodyLabel.rx.text.onNext(model.body)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTopSpacingConstraints()
        makeContentStackViewConstraints()
    }
}

extension QuestionTitleView {
    private func addViewSubComponents() {
        [topSpacing, contentStackView].forEach { addSubview($0) }
    }
    
    private func makeTopSpacingConstraints() {
        topSpacing.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(QuestionTitleViewNameSpace.topSpacing)
        }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(topSpacing.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [headerLabel, bodyLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

//extension QuestionTitleView {
//    func getHighlightTextList(to title: String, with highlight: [Int]) -> [String] {
//        var text: String = ""
//        var currendIndex: Int = highlight[0]
//        var previousIndex: Int = highlight[0]
//        var textList: [String] = []
//
//        highlight.forEach { index in
//            let stringIndex = title.index(title.startIndex, offsetBy: index)
//            let char: Character = title[stringIndex]
//
//            currendIndex = index
//
//            if (previousIndex - currendIndex) < -1 {
//                textList.append(text)
//                text.removeAll()
//            }
//
//            text.append(char)
//            previousIndex = index
//        }
//
//        textList.append(text)
//
//        return textList
//    }
//
//    func setDate(title: String, header: String, body: String, highlight: [Int]) {
//        self.headerLabel.text = header
//        self.bodyLabel.text = body
//
//        if !highlight.isEmpty {
//            let highlightTextList = self.getHighlightTextList(to: title, with: highlight)
//            self.bodyLabel.asColor(targetStringList: highlightTextList, color: UIColor(named: QuestionTitleViewNameSpace.bodyLabelHighlightColor))
//        }
//    }
//}

#if DEBUG

import SwiftUI

struct QuestionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTitleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: QuestionTitleViewNameSpace.height,
                   alignment: .center)
    }
    
    struct QuestionTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = QuestionTitleView()
            v.model.accept(.init(index: 0,
                                 pageNo: 0,
                                 title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
                                 header: "난 이게 가장 좋더라!",
                                 body: "당신이 가장 좋아하는 스킨십은?",
                                 highlight: [1, 2, 3],
                                 myAnser: "",
                                 partnerAnser: "",
                                 isMyAnswer: true,
                                 isPartnerAnswer: true,
                                 createAt: ""))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
