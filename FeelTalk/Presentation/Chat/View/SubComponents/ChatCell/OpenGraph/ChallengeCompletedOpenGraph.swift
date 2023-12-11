//
//  ChallengeCompletedOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCompletedOpenGraph: UIView {
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
        imageView.image = UIImage(named: "image_challenge_completed_open_graph")
        imageView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지를 멋지게 완료했어요!"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 16.0)
        label.setLineHeight(height: 24.0)
        label.backgroundColor = .red.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        stackView.backgroundColor = .orange.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     다섯글자임다섯글자임
                     """
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.setLineHeight(height: 21.0)
        label.numberOfLines = 0
        label.backgroundColor = .red.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var successDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2026년 5월 16일 성공"
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.backgroundColor = .red.withAlphaComponent(0.4)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
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
        addContentViewConstraints()
        addContentStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeTotalStackViewConstraints()
        makeTitleImageViewConstraints()
        makeContentViewConstraints()
        makeContentStackViewConstraints()
    }
}

extension ChallengeCompletedOpenGraph {
    private func addViewSubComponents() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [titleImageView, titleLabel, contentView].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(130.0)
            $0.height.equalTo(130.0)
        }
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(97.0)
        }
    }
    
    private func addContentViewConstraints() { contentView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(12.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [challengeTitleLabel, successDateLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCompletedOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCompletedOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 250,
                   height: 302,
                   alignment: .center)
    }
    
    struct ChallengeCompletedOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeCompletedOpenGraph()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
