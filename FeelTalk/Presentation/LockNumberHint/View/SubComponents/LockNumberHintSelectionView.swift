//
//  LockNumberHintSelectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberHintSelectionView: UIStackView {
    let viewTypeObserver = PublishRelay<LockNumberHintViewType>()
    let selectedHintObserver = PublishRelay<LockNumberHintType>()
    let isPickerSelectedObserver = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberHintSelectionViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var inputTitleView: CustomInputViewTitle = { CustomInputViewTitle(type: .lockNumberHint, isRequiredInput: false) }()
    
    private lazy var pickerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = LockNumberHintSelectionViewNameSpace.pickerButtonCornerRadius
        button.layer.borderWidth = LockNumberHintSelectionViewNameSpace.pickerButtonBorderWidth
        button.clipsToBounds = true
        
        viewTypeObserver
            .asObservable()
            .map { type -> Bool in type == .settings ? true : false }
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isPickerSelectedObserver
            .asObservable()
            .bind { state in
                if state {
                    button.rx.backgroundColor.onNext(.white)
                    button.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor)
                } else {
                    button.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                    button.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
                }
            }.disposed(by: disposeBag)
        
        button.rx.tap
            .asObservable()
            .withLatestFrom(isPickerSelectedObserver)
            .map { !$0 }
            .bind(to: isPickerSelectedObserver)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var buttonContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var selectedHintLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockNumberHintSelectionViewNameSpace.selectionHintLabelTextSize)
        
        selectedHintObserver
            .asObservable()
            .map { type -> String in type.convertLabelText() }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        
        viewTypeObserver
            .asObservable()
            .map { type -> Bool in type == .reset ? true : false }
            .bind(to: imageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        isPickerSelectedObserver
            .asObservable()
            .map { state -> String in
                state ?
                LockNumberHintSelectionViewNameSpace.arrowIconAbleTypeImage :
                LockNumberHintSelectionViewNameSpace.arrowIconDisableTypeImage
            }.map { imageStr -> UIImage in UIImage(named: imageStr) ?? UIImage() }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = LockNumberHintSelectionViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addPickerButtonConstraints()
        addButtonContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeInputTitleViewConstraints()
        makePickerButtonConstraints()
        makeButtonContentStackViewConstraints()
        makeArrowIconConstraints()
    }
}

extension LockNumberHintSelectionView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [inputTitleView, pickerButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeInputTitleViewConstraints() {
        inputTitleView.snp.makeConstraints {
            $0.height.equalTo(LockNumberHintSelectionViewNameSpace.inputTitleViewHeight)
        }
    }
    
    private func makePickerButtonConstraints() {
        pickerButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(LockNumberHintSelectionViewNameSpace.pickerButtonHeight)
        }
    }
    
    private func addPickerButtonConstraints() { pickerButton.addSubview(buttonContentStackView) }
    
    private func makeButtonContentStackViewConstraints() {
        buttonContentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(LockNumberHintSelectionViewNameSpace.buttonContentStackViewLeadingInset)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addButtonContentStackViewSubComponents() {
        [selectedHintLabel, arrowIcon].forEach { buttonContentStackView.addArrangedSubview($0) }
    }
    
    private func makeArrowIconConstraints() {
        arrowIcon.snp.makeConstraints {
            $0.width.equalTo(LockNumberHintSelectionViewNameSpace.arrowIconWidth)
            $0.height.equalTo(LockNumberHintSelectionViewNameSpace.arrowIconHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberHintSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberHintSelectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: LockNumberHintSelectionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct LockNumberHintSelectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = LockNumberHintSelectionView()
            v.viewTypeObserver.accept(.settings)
            v.selectedHintObserver.accept(.treasure)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
