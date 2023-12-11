//
//  ChallengeOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ChallengeChatModel {
    let type: ChatType
}

final class ChallengeOpenGraph: UIStackView {
    let model = PublishRelay<ChallengeChatModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var topSpacingView: UIView = { UIView() }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_challenge_open_graph")
        imageView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 16.0)
        label.setLineHeight(height: 24.0)
        label.textAlignment = .center
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
        stackView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D+999"
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        label.layer.cornerRadius = 8.0
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     다섯글자임다섯글자임
                     다섯글자임다섯글자임
                     """
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 14.0)
        label.setLineHeight(height: 21.0)
        label.numberOfLines = 0
        label.backgroundColor = .blue.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "2026년 5월 16일까지"
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.backgroundColor = .blue.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("보러가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                         size: 16.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = 40.0 / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var bottomSpacingView: UIView = { UIView() }()
    
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
                if model.type == .challengeChatting {
                    v.titleLabel.rx.text.onNext("챌린지를 진행하고 있어요!")
                } else if model.type == .addChallengeChatting {
                    v.titleLabel.rx.text.onNext("""
                                              새로운 챌린지를
                                              등록했어요 !
                                              """)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = 12.0
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentViewSubComponents()
        addContentStakcViewSubComponents()
    }
    
    private func setConstraints() {
        makeSpacingViewConstraints()
        makeTitleImageViewConstraints()
        makeContentViewConstraints()
        makeContentStackViewConstratins()
        makeDDayLabelConstraints()
        makeConfirmButtonConstraints()
    }
}

extension ChallengeOpenGraph {
    private func addViewSubComponents() {
        [topSpacingView, titleImageView, titleLabel, contentView, confirmButton, bottomSpacingView].forEach { addArrangedSubview($0) }
    }
    
    private func makeSpacingViewConstraints() {
        [topSpacingView, bottomSpacingView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(4)
            }}
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(130.0)
            $0.height.equalTo(130.0)
        }
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.width.equalTo(226.0)
            $0.height.equalTo(134.0)
        }
    }
    
    private func addContentViewSubComponents() { contentView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstratins() {
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.top.equalToSuperview().inset(12.0)
        }
    }
    
    private func addContentStakcViewSubComponents() {
        [dDayLabel, challengeTitleLabel, deadlineLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDDayLabelConstraints() {
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(54)
            $0.height.equalTo(34)
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(226.0)
            $0.height.equalTo(40.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 250,
                   height: 396,
                   alignment: .center)
    }
    
    struct ChallengeOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeOpenGraph()
            v.model.accept(ChallengeChatModel(type: .challengeChatting))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
