//
//  ChallengeCollectionHeaderView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCollectionHeaderView: UICollectionReusableView {
    let challengeTotalCount = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeCollectionHeaderViewNameSpace.headerLabelText
        label.textColor = .black
        label.font = UIFont(name: ChallengeCollectionHeaderViewNameSpace.headerLabelFont,
                            size: ChallengeCollectionHeaderViewNameSpace.headerLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: ChallengeCollectionHeaderViewNameSpace.bodyLabelFont,
                            size: ChallengeCollectionHeaderViewNameSpace.bodyLabelFextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        challengeTotalCount
            .withUnretained(self)
            .bind { v, count in
                v.bodyLabel.rx.text.onNext("\(count)개의 챌린지")
                v.bodyLabel.asColor(targetStringList: ["\(count)개"],
                                    color: UIColor(named: ChallengeCollectionHeaderViewNameSpace.bodyLabelHighlightTextColor))
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addHeaderViewSubComponent()
        addStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeStackViewConstraints()
    }
}

extension ChallengeCollectionHeaderView {
    private func addHeaderViewSubComponent() { addSubview(stackView) }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeCollectionHeaderViewNameSpace.stackViewTopInset)
            $0.leading.equalToSuperview().inset(ChallengeCollectionHeaderViewNameSpace.stackViewLeadingInset)
            $0.bottom.equalTo(stackView.snp.top).offset(ChallengeCollectionHeaderViewNameSpace.stackViewHeight)
        }
    }
    
    private func addStackViewSubComponents() {
        [headerLabel, bodyLabel].forEach { stackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCollectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCollectionHeaderView_Presentable()
    }
    
    struct ChallengeCollectionHeaderView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeCollectionHeaderView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
