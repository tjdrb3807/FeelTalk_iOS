//
//  AdultAuthConsentButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthConsentButton: UIButton {
    let isConsented = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = AdultAuthConsentButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var checkIcon: UIImageView = { UIImageView() }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthConsentButtonNameSpace.contentLabelText
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: AdultAuthConsentButtonNameSpace.contentLabelTextSize)
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var rightArrowIcon: UIImageView = { UIImageView(image: UIImage(named: AdultAuthConsentButtonNameSpace.rightArrowIconImage)) }()
    
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
        isConsented
            .withUnretained(self)
            .bind { v, state in
                state ?
                v.checkIcon.rx.image.onNext(UIImage(named: AdultAuthConsentButtonNameSpace.checkIconActiveImage)) :
                v.checkIcon.rx.image.onNext(UIImage(named: AdultAuthConsentButtonNameSpace.checkIconNonActiveImage))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.borderWidth = AdultAuthConsentButtonNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray400)?.cgColor
        layer.cornerRadius = AdultAuthConsentButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeCheckIconConstraints()
        makeRightArrowIconConstraints()
    }
}

extension AdultAuthConsentButton {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AdultAuthConsentButtonNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(AdultAuthConsentButtonNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(AdultAuthConsentButtonNameSpace.contentStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(AdultAuthConsentButtonNameSpace.contentStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [checkIcon, contentLabel, rightArrowIcon].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeCheckIconConstraints() {
        checkIcon.snp.makeConstraints { $0.width.equalTo(checkIcon.snp.height) }
    }
    
    private func makeRightArrowIconConstraints() {
        rightArrowIcon.snp.makeConstraints { $0.width.equalTo(rightArrowIcon.snp.height) }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthConsentButton_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthConsentButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthConsentButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthConsentButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthConsentButton()
            v.isConsented.accept(false)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
