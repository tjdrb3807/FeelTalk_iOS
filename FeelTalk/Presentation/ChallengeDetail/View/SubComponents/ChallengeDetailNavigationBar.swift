//
//  ChallengeDetailNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailNavigationBar: UIView {
    private let disposeBag = DisposeBag()
    let viewMode = PublishRelay<ChallengeDetailViewMode>()
    
    lazy var popButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChallengeDetailNavigationBarNameSpace.popButtonImage),
                        for: .normal)
        
        return button
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChallengeDetailNavigationBarNameSpace.modifiyButtonImage), for: .normal)
        
        return button
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChallengeDetailNavigationBarNameSpace.removeButtonImage), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttribute()
        self.addSubComponent()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.updateNavigationItems(mode)
            }.disposed(by: disposeBag)
    }
    
    
    private func setAttribute() { backgroundColor = .clear }
    
    private func addSubComponent() {
        [popButton, modifyButton, removeButton].forEach { addSubview($0) }
    }
    
    private func setConfiguration() {
        makePopButtonConstraints()
        makeModifyButtonConstraints()
        makeRemoveButtonConstraints()
    }
}

extension ChallengeDetailNavigationBar {
    private func makePopButtonConstraints() {
        popButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonTopInset)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(popButton.snp.leading).offset(ChallengeDetailNavigationBarNameSpace.buttomWidth)
            $0.bottom.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonBottomInset)
        }
    }
    
    private func makeModifyButtonConstraints() {
        modifyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonTopInset)
            $0.leading.equalTo(modifyButton.snp.trailing).offset(-ChallengeDetailNavigationBarNameSpace.buttomWidth)
            $0.trailing.equalTo(removeButton.snp.leading)
            $0.bottom.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonBottomInset)
        }
    }
    
    private func makeRemoveButtonConstraints() {
        removeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonTopInset)
            $0.leading.equalTo(removeButton.snp.trailing).offset(-ChallengeDetailNavigationBarNameSpace.buttomWidth)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.buttonBottomInset)
        }
    }
}

extension ChallengeDetailNavigationBar {
    func updateNavigationItems(_ mode: ChallengeDetailViewMode) {
        switch mode {
        case .new:
            modifyButton.rx.isHidden.onNext(true)
            removeButton.rx.isHidden.onNext(true)
        case .ongoing, .completed, .modify:
            modifyButton.rx.isHidden.onNext(false)
            removeButton.rx.isHidden.onNext(false)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailNavigationBar_Presentable()
    }
    
    struct ChallengeDetailNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailNavigationBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
