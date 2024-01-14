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
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    let tapButtonObserver = PublishRelay<ChallengeDetailNavigationBarButtonType>()
    private let disposeBag = DisposeBag()
    
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
        typeObserver
            .withUnretained(self)
            .bind { v, type in
                v.updateItems(with: type)
            }.disposed(by: disposeBag)
        
        Observable<ChallengeDetailNavigationBarButtonType>
            .merge(popButton.rx.tap.map { .pop }.asObservable(),
                   modifyButton.rx.tap.map { .modify }.asObservable(),
                   removeButton.rx.tap.map { .remove }.asObservable())
            .bind(to: tapButtonObserver)
            .disposed(by: disposeBag)
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
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(ChallengeDetailNavigationBarNameSpace.buttonWidth)
            $0.height.equalTo(ChallengeDetailNavigationBarNameSpace.buttonHeight)
        }
    }
    
    private func makeModifyButtonConstraints() {
        modifyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ChallengeDetailNavigationBarNameSpace.modifiyButtonTrailingInset)
            $0.width.equalTo(ChallengeDetailNavigationBarNameSpace.buttonWidth)
            $0.height.equalTo(ChallengeDetailNavigationBarNameSpace.buttonWidth)
        }
    }
    
    private func makeRemoveButtonConstraints() {
        removeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(ChallengeDetailNavigationBarNameSpace.buttonWidth)
            $0.height.equalTo(ChallengeDetailNavigationBarNameSpace.buttonHeight)
        }
    }
}

extension ChallengeDetailNavigationBar {
    private func updateItems(with type: ChallengeDetailViewType) {
        switch type {
        case .completed:
            modifyButton.rx.isHidden.onNext(true)
            removeButton.rx.isHidden.onNext(false)
        case .modify, .new:
            modifyButton.rx.isHidden.onNext(true)
            removeButton.rx.isHidden.onNext(true)
        case .ongoing:
            modifyButton.rx.isHidden.onNext(false)
            removeButton.rx.isEnabled.onNext(false)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailNavigationBar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeDetailNavigationBarNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeDetailNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeDetailNavigationBar()
            v.typeObserver.accept(.ongoing)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
