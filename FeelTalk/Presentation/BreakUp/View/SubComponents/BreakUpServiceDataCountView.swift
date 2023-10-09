//
//  BreakUpServiceDataCountView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BreakUpServiceDataCountView: UIStackView {
    let questionCount = PublishRelay<Int>()
    let challengeCount = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = BreakUpServiceDataCountViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: BreakUpServiceDataCountViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear

        return label
    }()
    
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = BreakUpServiceDataCountViewNameSpace.countStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var questionCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = BreakUpServiceDataCountViewNameSpace.serviceCountStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var questionCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardBold,
                            size: BreakUpServiceDataCountViewNameSpace.serviceCountLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = BreakUpServiceDataCountViewNameSpace.questionDescriptionLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: BreakUpServiceDataCountViewNameSpace.serviceDescriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var challengeContStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = BreakUpServiceDataCountViewNameSpace.serviceCountStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var challengeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardBold,
                            size: BreakUpServiceDataCountViewNameSpace.serviceCountLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var challengeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = BreakUpServiceDataCountViewNameSpace.challengeDescriptionLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: BreakUpServiceDataCountViewNameSpace.serviceDescriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind (){
        questionCount
            .map { count in "\(count)" }
            .withUnretained(self)
            .bind { v, count in
                v.questionCountLabel.rx.text.onNext(count)
                v.questionCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            }.disposed(by: disposeBag)
        
        challengeCount
            .map { count in "\(count)" }
            .withUnretained(self)
            .bind { v, count in
                v.challengeCountLabel.rx.text.onNext(count)
                v.challengeCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = BreakUpServiceDataCountViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addCountStackViewSubComponents()
        addQuestionCountStackViewSubComponents()
        addChallengeCountStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeDescriptionLabelConstraints()
    }
}

extension BreakUpServiceDataCountView {
    private func addViewSubComponents() {
        [descriptionLabel, countStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(BreakUpServiceDataCountViewNameSpace.descriptionLabelHeight) }
    }
    
    private func addCountStackViewSubComponents() {
        [questionCountStackView, challengeContStackView].forEach { countStackView.addArrangedSubview($0) }
    }
    
    private func addQuestionCountStackViewSubComponents() {
        [questionCountLabel, questionDescriptionLabel].forEach { questionCountStackView.addArrangedSubview($0) }
    }
    
    
    private func addChallengeCountStackViewSubComponents() {
        [challengeCountLabel, challengeDescriptionLabel].forEach { challengeContStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct BreakUpDataCountView_Previews: PreviewProvider {
    static var previews: some View {
        BreakUpServiceDataCountView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: BreakUpServiceDataCountViewNameSpace.height,
                   alignment: .center)
    }
    
    struct BreakUpServiceDataCountView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = BreakUpServiceDataCountView()
            view.questionCount.accept(64)
            view.challengeCount.accept(4)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
