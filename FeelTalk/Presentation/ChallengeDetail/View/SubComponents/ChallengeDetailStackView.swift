//
//  ChallengeDetailStackView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit

final class ChallengeDetailStackView: UIStackView {
    lazy var titleInputView: ChallengeDetailTitleInputView = { ChallengeDetailTitleInputView() }()
    lazy var deadlineInputView: ChallengeDetailDeadlineInputView = { ChallengeDetailDeadlineInputView() }()
    lazy var contentInputView: ChallengeDetailContentInputView = { ChallengeDetailContentInputView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = ChallengeDetailStackViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [titleInputView, deadlineInputView, contentInputView].forEach { addArrangedSubview($0) }
    }
    
    private func setConfigurations() {
        makeTitleInputViewConstratins()
        makeDeadlineInputViewConstraints()
        makeContentInputViewConstraints()
    }
}

extension ChallengeDetailStackView {
    private func makeTitleInputViewConstratins() {
        titleInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChallengeDetailTitleInputViewNameSpace.height)
        }
    }
    
    private func makeDeadlineInputViewConstraints() {
        deadlineInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChallengeDetailDeadlineInputViewNameSpace.height)
        }
    }
    
    private func makeContentInputViewConstraints() {
        contentInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailStackView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailStackView_Presentable()
    }
    
    struct ChallengeDetailStackView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailStackView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
