//
//  LockingPasswordDisplayView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingPasswordDisplayView: UIStackView {
    let viewMode = PublishRelay<LockingPasswordViewMode>()
    private let disposeBag = DisposeBag()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = LockingPasswordDisplayViewNameSpace.labelStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockingPasswordDisplayViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: LockingPasswordDisplayViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockingPasswordDisplayViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: LockingPasswordDisplayViewNameSpace.descriptionLabelLineHeight)
        
        return label
    }()
    
    private lazy var passwordInputView = { LockingPasswordInputView() }()
    
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
    
    private func bind() {
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.setData(with: mode)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = LockingPasswordDisplayViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makePasswordInputViewConstraints()
    }
}

extension LockingPasswordDisplayView {
    private func addViewSubComponents() {
        [labelStackView, passwordInputView].forEach { addArrangedSubview($0) }
    }
    
    private func makePasswordInputViewConstraints() {
        passwordInputView.snp.makeConstraints {
            $0.width.equalTo(LockingPasswordInputViewNameSpace.width)
            $0.height.equalTo(LockingPasswordInputViewNameSpace.height)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

extension LockingPasswordDisplayView {
    private func setData(with mode: LockingPasswordViewMode) {
        setTitleLabelText(with: mode)
        setDescriptionLabelText(with: mode)
    }
    
    private func setTitleLabelText(with mode: LockingPasswordViewMode) {
        switch mode {
        case .settings:
            titleLabel.rx.text.onNext(LockingPasswordDisplayViewNameSpace.titleLabelSettingsModeText)
        case .change:
            titleLabel.rx.text.onNext(LockingPasswordDisplayViewNameSpace.titleLabelChangeModeText)
        }
    }
    
    private func setDescriptionLabelText(with mode: LockingPasswordViewMode) {
        switch mode {
        case .settings:
            descriptionLabel.rx.text.onNext(LockingPasswordDisplayViewNameSpace.descriptionLabelSettingsModeText)
        case .change:
            descriptionLabel.rx.text.onNext(LockingPasswordDisplayViewNameSpace.descriptionLabelChangeModeText)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingPasswordDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        LockingPasswordDisplayView_Presentable()
    }
    
    struct LockingPasswordDisplayView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = LockingPasswordDisplayView()
            view.viewMode.accept(.settings)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

