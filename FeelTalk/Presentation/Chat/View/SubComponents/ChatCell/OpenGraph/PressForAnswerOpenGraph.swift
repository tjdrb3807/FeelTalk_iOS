//
//  PressForAnswerOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/03/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PressForAnswerOpenGraph: UIView {
    private lazy var totalContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    private lazy var fingerImage: UIImageView = { UIImageView(image: UIImage(named: "image_press_for_answer_open_graph")) }()
    
    private lazy var contentStakcView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쿡쿡👉 답장해줘!😑"
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: 16.0)
        label.setLineHeight(height: 24.0)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                      연인이 나의 답변을 궁금해하고 있어요.
                      오늘의 질문에 답변해 보세요.
                      """
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 12.0)
        label.numberOfLines = 0
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var answerButton: UIButton = {
        let button = UIButton()
        button.setTitle("답변하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 16.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = 40.0 / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: 250.0,
                height: 244.0)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTotalContentStackViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalContentStackViewConstraints()
        makeAnswerButtonConstraints()
    }
}

extension PressForAnswerOpenGraph {
    private func addViewSubComponents() { addSubview(totalContentStackView) }
    
    private func makeTotalContentStackViewConstraints() {
        totalContentStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func addTotalContentStackViewSubComponents() {
        [fingerImage, contentStakcView, answerButton].forEach { totalContentStackView.addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { contentStakcView.addArrangedSubview($0) }
    }
    
    private func makeAnswerButtonConstraints() {
        answerButton.snp.makeConstraints {
            $0.width.equalTo(226.0)
            $0.height.equalTo(40.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct PressForAnswerOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        PressForAnswerOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 250.0,
                height: 244.0,
                alignment: .center)
    }
    
    struct PressForAnswerOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PressForAnswerOpenGraph()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

