//
//  WithdrawalReasonCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class WithdrawalReasonCell: UIView {
    let type = BehaviorRelay<WithdrawalReasonsType>(value: .none)
    let isSelected = BehaviorRelay<Bool>(value: false)
    let etcReason = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = WithdrawalReasonCellNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = WithdrawalReasonCellNameSpace.headerStackViewSpacing
        
        return stackView
    }()
    
    private lazy var checkIcon: UIImageView = { UIImageView() }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: WithdrawalReasonCellNameSpace.titleLabelTextSize)
        label.setLineHeight(height: WithdrawalReasonCellNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var reasonInputTextView: CustomTextView = { CustomTextView(
        placeholder: WithdrawalReasonCellNameSpace.reasonInputTextViewPlaceholder,
        maxTextCout: WithdrawalReasonCellNameSpace.reasonInputTextViewMaxCount)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        
        self.reasonInputTextView.textView.rx.text
            .filter {
                $0 != WithdrawalReasonCellNameSpace.reasonInputTextViewPlaceholder
            }
            .bind(to: self.etcReason)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        type
            .skip(1)
            .map { $0.rawValue }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        isSelected
            .withUnretained(self)
            .bind { v, state in
                state ?
                v.checkIcon.rx.image.onNext(UIImage(named: WithdrawalReasonCellNameSpace.checkIconSelectedImage)) :
                v.checkIcon.rx.image.onNext(UIImage(named: WithdrawalReasonCellNameSpace.checkIconUnselectedImage))
            }.disposed(by: disposeBag)
        
        type
            .skip(1)
            .take(1)
            .filter { $0 == .etc }
            .withUnretained(self)
            .bind { c, _ in
                c.contentStackView.insertArrangedSubview(c.reasonInputTextView, at: 1)
                
                c.reasonInputTextView.snp.makeConstraints {
                    $0.width.equalTo(WithdrawalReasonCellNameSpace.reasonInputTextViewWidth)
                    $0.bottom.equalTo(c.reasonInputTextView.snp.top).offset(WithdrawalReasonCellNameSpace.reasonInputTextViewDefaultHeight)
                }
            }.disposed(by: disposeBag)
        
        isSelected
            .skip(1)
            .withLatestFrom(type) { (isSelected: $0, type: $1) }
            .filter { $0.type == .etc }
            .map { $0.isSelected }
            .withUnretained(self)
            .bind { c, isSelected in
                c.updateETCCellConstraints(with: isSelected)
                c.updateReasonInputTextFieldConstraints(with: isSelected)
            }.disposed(by: disposeBag)
    }
    
    private func updateETCCellConstraints(with isSeelcted: Bool) {
        if isSeelcted {
            snp.updateConstraints { $0.bottom.equalTo(snp.top).offset(WithdrawalReasonCellNameSpace.updateHeight) }
        } else {
            snp.updateConstraints { $0.bottom.equalTo(snp.top).offset(WithdrawalReasonCellNameSpace.defaultHeight) }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .allowAnimatedContent,
                animations: { self.superview?.layoutSubviews() })
        }
    }
    
    private func updateReasonInputTextFieldConstraints(with isSelected: Bool) {
        if isSelected {
            reasonInputTextView.snp.updateConstraints {
                $0.bottom.equalTo(reasonInputTextView.snp.top).offset(WithdrawalReasonCellNameSpace.reasonInputTextViewUpdateHeight)
            }
        } else {
            reasonInputTextView.snp.updateConstraints {
                $0.bottom.equalTo(reasonInputTextView.snp.top).offset(WithdrawalReasonCellNameSpace.reasonInputTextViewDefaultHeight)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .allowAnimatedContent,
                animations: { self.layoutSubviews() })
        }
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.borderWidth = WithdrawalReasonCellNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray300)?.cgColor
        layer.cornerRadius = WithdrawalReasonCellNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addHeaderStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeCheckIconConstraints()
    }
}

extension WithdrawalReasonCell {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(WithdrawalReasonCellNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(WithdrawalReasonCellNameSpace.contentStackViewLeadingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        contentStackView.addArrangedSubview(headerStackView)
    }
    
    private func addHeaderStackViewSubComponents() {
        [checkIcon, titleLabel].forEach { headerStackView.addArrangedSubview($0) }
    }
    
    private func makeCheckIconConstraints() {
        checkIcon.snp.makeConstraints {
            $0.width.equalTo(WithdrawalReasonCellNameSpace.checkIconWidth)
            $0.height.equalTo(WithdrawalReasonCellNameSpace.checkIconHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalReasonCell_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalReasonCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: WithdrawalReasonCellNameSpace.defaultHeight,
                   alignment: .center)
    }
    
    struct WithdrawalReasonCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = WithdrawalReasonCell()
            v.type.accept(.etc)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
