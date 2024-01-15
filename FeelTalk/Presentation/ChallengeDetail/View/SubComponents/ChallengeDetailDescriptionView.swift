//
//  ChallengeDetailDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailDescriptionView: UIStackView {
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    private let disposeBag = DisposeBag()
    
    private lazy var leftSpacing: UIView = { UIView() }()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeDetailDescriptionViewNameSpace.labelTextSize)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeDetailDescriptionViewNameSpace.labelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        typeObserver
            .withUnretained(self)
            .bind { v, event in
                v.setLabelProperties(with: event)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeDetailDescriptionViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTopSpacingConstraints()
        makeBottomSpacingConstraints()
    }
}

extension ChallengeDetailDescriptionView {
    private func addViewSubComponents() {
        [leftSpacing, contentStackView].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [topSpacing, headerLabel, bodyLabel, bottomSpacing].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTopSpacingConstraints() {
        topSpacing.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChallengeDetailDescriptionViewNameSpace.topSpacingHeight)
        }
    }
    
    private func makeBottomSpacingConstraints() {
        bottomSpacing.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChallengeDetailDescriptionViewNameSpace.bottomSpacingHeight)
        }
    }
}

extension ChallengeDetailDescriptionView {
    private func setLabelProperties(with type: ChallengeDetailViewType) {
        switch type {
        case .completed, .ongoing:
            headerLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.headerLabelType01Text)
            bodyLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.bodyLabelType01Text)
        case .modify, .new:
            headerLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.headerLabelType02Text)
            bodyLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.bodyLabelType02Text)
        }
        
        [headerLabel, bodyLabel].forEach {
            $0.setLineHeight(height: ChallengeDetailDescriptionViewNameSpace.labelLineHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailDescriptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeDetailDescriptionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeDetailDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeDetailDescriptionView()
            v.typeObserver.accept(.completed)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
