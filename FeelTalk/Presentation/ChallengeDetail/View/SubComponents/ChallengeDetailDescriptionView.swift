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
    let viewMode = PublishRelay<ChallengeDetailViewMode>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var leftSpacingView: UIView = { UIView() }()
    
    private lazy var rightSpacingView: UIView = { UIView() }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailDescriptionViewNameSpace.headerLabelNewOrModifyModeText
        label.textColor = .black
        label.font = UIFont(name: ChallengeDetailDescriptionViewNameSpace.headerLabelTextFont,
                            size: ChallengeDetailDescriptionViewNameSpace.headerLabelTextSize)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailDescriptionViewNameSpace.bodyLabelNewOrModifiyModeText
        label.textColor = .black
        label.font = UIFont(name: ChallengeDetailDescriptionViewNameSpace.bodyLabelTextFont,
                            size: ChallengeDetailDescriptionViewNameSpace.bodyLabelTextSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.setTitle(with: mode)
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
        addStackViewSubComponents()
    }
}

extension ChallengeDetailDescriptionView {
    private func setTitle(with mode: ChallengeDetailViewMode) {
        switch mode {
        case .new, .modify:
            headerLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.headerLabelNewOrModifyModeText)
            bodyLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.bodyLabelNewOrModifiyModeText)
        case .ongoing, .completed:
            headerLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.headerLabelOngoingOrCompletedModeText)
            bodyLabel.rx.text.onNext(ChallengeDetailDescriptionViewNameSpace.bodyLabelOngoingOrCompletedModeText)
        }
    }
    
    private func addViewSubComponents() {
        [leftSpacingView, stackView, rightSpacingView].forEach { addArrangedSubview($0) }
    }
    
    private func addStackViewSubComponents() {
        [headerLabel, bodyLabel].forEach { stackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailDescriptionView_Presentable()
    }
    
    struct ChallengeDetailDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailDescriptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
