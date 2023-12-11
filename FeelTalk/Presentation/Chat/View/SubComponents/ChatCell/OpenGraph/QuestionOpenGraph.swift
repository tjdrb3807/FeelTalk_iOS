//
//  QuestionOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionOpenGraph: UIView {
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var titlaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_question_open_graph")
        imageView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        stackView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .blue.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var questionTitelLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 난 이게 가장 좋더라!"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.setLineHeight(height: 21.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var questionBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "당신이 가장 좋아하는 스킨십은?"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.setLineHeight(height: 21.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.06.01"
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        label.backgroundColor = .white
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     연인이 답변을 기다리고 있어요.
                     아래의 버튼을 눌러
                     오늘의 질문에 답해보세요!
                     """
        label.numberOfLines = 0
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        label.backgroundColor = .white
        
        return label
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
        addViewSubComponents()
        addTotalStackViewSubComponents()
        addContentStackViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeTitleImageViewConstraints()
    }
}

extension QuestionOpenGraph {
    private func addViewSubComponents() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [titlaImageView, contentStackView, descriptionLabel].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titlaImageView.snp.makeConstraints {
            $0.width.equalTo(72.0)
            $0.height.equalTo(72.0)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [labelStackView, dateLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func addLabelStackViewSubComponents() {
        [questionTitelLabel, questionBodyLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct QuestionOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        QuestionOpenGraph_Presentable()
    }
    
    struct QuestionOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionOpenGraph()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
