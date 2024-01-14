//
//  AdultAuthAlertView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthAlertView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var contentView: UIView  = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = AdultAuthAlertViewNameSpace.contentViewCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = AdultAuthAlertViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = AdultAuthAlertViewNameSpace.labelStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthAlertViewNameSpace.titleLabelText
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: AdultAuthAlertViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: AdultAuthAlertViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthAlertViewNameSpace.descriptionLabelText
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthAlertViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: AdultAuthAlertViewNameSpace.descriptionLabelLineHeight)
        
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle(AdultAuthAlertViewNameSpace.checkButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                         size: AdultAuthAlertViewNameSpace.checkButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = AdultAuthAlertViewNameSpace.checkButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        checkButton.rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.hide()
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewSubComponents()
        makeContentViewConstraints()
        makeCheckButtonConstraints()
    }
}

extension AdultAuthAlertView {
    private func addViewSubComponents() {
        [contentView, contentStackView].forEach { addSubview($0) }
    }
    
    private func makeContentStackViewSubComponents() {
        contentStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.top).offset(AdultAuthAlertViewNameSpace.contentViewTopOffset)
            $0.leading.equalTo(contentStackView.snp.leading).offset(AdultAuthAlertViewNameSpace.contentViewLeadingOffset)
            $0.trailing.equalTo(contentStackView.snp.trailing).offset(AdultAuthAlertViewNameSpace.contentViewTrailingOffset)
            $0.bottom.equalTo(contentStackView.snp.bottom).offset(AdultAuthAlertViewNameSpace.contentViewBottomOffset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [labelStackView, checkButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeCheckButtonConstraints() {
        checkButton.snp.makeConstraints {
            $0.width.equalTo(AdultAuthAlertViewNameSpace.checkButtonWidth)
            $0.height.equalTo(AdultAuthAlertViewNameSpace.checkButtonHeight)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

extension AdultAuthAlertView {
    public func show(completion: @escaping () -> Void = {}) {
        contentStackView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(AdultAuthAlertViewNameSpace.contentStackViewTopInset)
        }
        
        UIView.animate(
            withDuration: AdultAuthAlertViewNameSpace.animateDuration,
            delay: AdultAuthAlertViewNameSpace.animateDelay,
            options: .curveEaseInOut,
            animations: { self.backgroundColor = UIColor.black.withAlphaComponent(AdultAuthAlertViewNameSpace.backgroundColorAlpha) },
            completion: nil
        )
        
        UIView.animate(
            withDuration: AdultAuthAlertViewNameSpace.animateDuration,
            delay: AdultAuthAlertViewNameSpace.animateDelay,
            usingSpringWithDamping: AdultAuthAlertViewNameSpace.damping,
            initialSpringVelocity: AdultAuthAlertViewNameSpace.springVelocity,
            options: [],
            animations: self.layoutIfNeeded,
            completion: { _ in completion() }
        )
    }
    
    public func hide(completion: @escaping () -> Void = {}) {
        contentStackView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + AdultAuthAlertViewNameSpace.animateDelay) { [weak self] in
            guard let self = self else { return }
            
            removeFromSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthAlertView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct AdultAuthAlertView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthAlertView()
            v.show()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
