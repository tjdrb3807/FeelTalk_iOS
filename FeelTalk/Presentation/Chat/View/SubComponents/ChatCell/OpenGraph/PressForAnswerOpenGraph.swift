//
//  PressForAnswerOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PressForAnswerOpenGraph: UIView {
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_press_for_answer_open_graph")
        imageView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        stackView.backgroundColor = .orange.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쿡쿡👉 답장해줘!😑"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 16.0)
        label.setLineHeight(height: 24.0)
        label.backgroundColor = .red.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     연인이 나의 답변을 궁금해하고 있어요. 오늘의 질문에 답변해 보세요.
                     """
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        label.backgroundColor = .red.withAlphaComponent(0.4)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var answerButton: UIButton = {
        let button = UIButton()
        button.setTitle("답변하기",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                         size: 16.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = 40 / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubcomponents()
        addTotalStackViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeTitleImageViewConstraints()
        makeAnswerButtonConstraints()
    }
}

extension PressForAnswerOpenGraph {
    private func addViewSubcomponents() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [titleImageView, contentStackView, answerButton].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(150.0)
            $0.height.equalTo(150.0)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeAnswerButtonConstraints() {
        answerButton.snp.makeConstraints {
            $0.width.equalToSuperview()
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
            .frame(width: 250,
                   height: 310,
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
