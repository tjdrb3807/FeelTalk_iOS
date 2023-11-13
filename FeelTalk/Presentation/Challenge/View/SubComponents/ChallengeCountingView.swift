//
//  ChallengeCountingView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCountingView: UIView {
    let model = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var firstAdditionalLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeCountingViewNameSpace.firstAdditionalLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeCountingViewNameSpace.firstAdditionalLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var totalCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeCountingViewNameSpace.totalCountLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var secondAdditionalLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeCountingViewNameSpace.secondAdditionalLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeCountingViewNameSpace.secondAdditionalLabelTextSize)
        label.backgroundColor = .clear
        
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
        model
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, count in
                v.totalCountLabel.rx.text.onNext("\(count)\(ChallengeCountingViewNameSpace.totalCountLabelSubText)")
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addCountStackViewSubComponents()
    }
    
    private func setConstraints() { makeContentStackViewConstraints() }
}

extension ChallengeCountingView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeCountingViewNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalToSuperview().offset(ChallengeCountingViewNameSpace.contentStackViewBottomOffset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [firstAdditionalLabel, countStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func addCountStackViewSubComponents() {
        [totalCountLabel, secondAdditionalLabel].forEach { countStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCountingView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCountingView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeCountingViewNameSpace.Height,
                   alignment: .center)
    }
    
    struct ChallengeCountingView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeCountingView()
            v.model.accept(99)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
