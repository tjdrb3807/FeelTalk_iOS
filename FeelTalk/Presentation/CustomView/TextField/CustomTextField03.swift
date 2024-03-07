//
//  CustomTextField03.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum TextFieldInputWarringTpye: String {
    case exceedingLetters = "최대 10글자까지 입력할 수 있어요"
    case useSpecialCharOfSpace = "특수문자, 공백은 사용할 수 없어요"
    case none = ""
}

final class CustomTextField03: UIStackView {
    private let isFocusedObserver = BehaviorRelay<Bool>(value: false)
    private let warningObserver = BehaviorRelay<TextFieldInputWarringTpye>(value: .none)
    private let disposeBag = DisposeBag()
    
    private var maxNumOfChar: Int?
    private var regularExPression: RegularExpression?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: CustomTextFieldNameSpace03.textFieldTextSize)
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        textField.layer.borderWidth = CustomTextFieldNameSpace03.textFieldBorderWidth
        textField.layer.cornerRadius = CustomTextFieldNameSpace03.textFieldCornerRadius
        textField.autocorrectionType = .no
        textField.clipsToBounds = true
        
        let leftView = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: CustomTextFieldNameSpace03.textFieldLeftViewWidth,
                    height: textField.frame.height)))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        Observable<Bool>
            .merge(textField.rx.controlEvent(.editingDidBegin).map { _ -> Bool in true },
                   textField.rx.controlEvent(.editingDidEnd).map { _ -> Bool in false }
            ).bind(to: isFocusedObserver)
            .disposed(by: disposeBag)
        
        isFocusedObserver
            .bind { event in
                if event {
                    textField.rx.backgroundColor.onNext(.white)
                    textField.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor)
                } else {
                    textField.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
                    textField.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
                }
            }.disposed(by: disposeBag)
        
        textField.rx.changeText
            .orEmpty
            .skip(1)
            .scan(textField.text) { [weak self] prev, new -> String? in
                guard let self = self,
                      let prev = prev,
                      let maxNumOfChar = self.maxNumOfChar,
                      let regularExPression = self.regularExPression else { return prev }
                let pattern = regularExPression.rawValue

                if new.count > maxNumOfChar {
                    warningObserver.accept(.exceedingLetters)
                    return prev
                }
                do {
                    let regex = try NSRegularExpression(
                        pattern: pattern,
                        options: .caseInsensitive)
                    if let h = regex.firstMatch(
                        in: new,
                        options: NSRegularExpression.MatchingOptions.reportCompletion,
                        range: NSMakeRange(0, new.count)) {
                        countView?.molecularCount.accept(new.count)
                        warningObserver.accept(.none)
                        return new
                    }
                } catch {
                    warningObserver.accept(.none)
                    countView?.molecularCount.accept(prev.count)
                    return prev
                }

                warningObserver.accept(.useSpecialCharOfSpace)
                countView?.molecularCount.accept(prev.count)
                return prev
            }.asDriver(onErrorJustReturn: "")
            .drive(textField.rx.text)
            .disposed(by: disposeBag)
        
        return textField
    }()
    
    private var countView: TextCountingView?
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = CustomTextFieldNameSpace03.labelStackViewSpacing
        
        warningObserver
            .distinctUntilChanged()
            .map { type -> Bool in
                type == .none ? true : false
            }.asDriver(onErrorJustReturn: true)
            .drive(stackView.rx.isHidden)
            .disposed(by: disposeBag)
            
        return stackView
    }()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: CustomTextFieldNameSpace03.warningLabelTextSize)
        
        warningObserver
            .distinctUntilChanged()
            .map { $0.rawValue }
            .asDriver(onErrorJustReturn: .none)
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    init(placeholder: String?, isClearButtonNeeded: Bool, maxNumOfChar: Int?, regularExpression: RegularExpression?) {
        self.maxNumOfChar = maxNumOfChar
        self.regularExPression = regularExpression
        
        super.init(frame: .zero)
        
        self.textField.setPlaceholder(text: placeholder, color: UIColor(named: CommonColorNameSpace.gray400)!)
        self.setCountView(maxNumOfChar: maxNumOfChar)
        self.setClearButton(isClearButtonNeeded)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = CustomTextFieldNameSpace03.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTextFieldConstraints()
        makeLabelStackViewConstraints()
    }
}

extension CustomTextField03 {
    private func addViewSubComponents() {
        [textField, labelStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeTextFieldConstraints() {
        textField.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(CustomTextFieldNameSpace03.textFieldHeight)
        }
    }
    
    private func makeLabelStackViewConstraints() {
        labelStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(CustomTextFieldNameSpace03.warningLabelTextSize)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [leadingSpacing, warningLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

extension CustomTextField03 {
    private func setClearButton(_ isClearButtonNeeded: Bool) {
        if isClearButtonNeeded {
            textField.setClearButton(
                with: UIImage(named: InquiryEmailInputViewNameSpace.emailInputTextFieldClearButtonImage) ?? UIImage(),
                mode: .whileEditing)
        } else {
            return
        }
    }
    
    private func setCountView(maxNumOfChar: Int?) {
        guard let maxNumOfChar = maxNumOfChar else { return }
        let countView = TextCountingView(denominator: maxNumOfChar)
        self.countView = countView
        
        textField.addSubview(self.countView ??  UIView())
        
        self.countView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CustomTextFieldNameSpace03.countViewTrailingInset)
        }
        
        Observable
            .combineLatest(
                isFocusedObserver,
                textField.rx.changeText.orEmpty.map { text -> Bool in text.isEmpty }) { (isFocused: $0, isEmpty: $1) }
            .withUnretained(self)
            .bind { v, event in
                if !event.isFocused {
                    v.updateCountViewConstratins(isClearButtonHidden: true)
                } else {
                    if event.isEmpty {
                        v.updateCountViewConstratins(isClearButtonHidden: true)
                    } else {
                        v.updateCountViewConstratins(isClearButtonHidden: false)
                    }
                }
            }.disposed(by: disposeBag)
    }
}

extension CustomTextField03 {
    private func updateCountViewConstratins(isClearButtonHidden: Bool) {
        if isClearButtonHidden {
            countView?.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewDefaultTrailingInset)
            }
        } else {
            countView?.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewUpdateTrailingInset)
            }
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomTextField03_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField03_Presentable()
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: CustomTextFieldNameSpace03.textFieldHeight,
                   alignment: .center)
    }
    
    struct CustomTextField03_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextField03(
                placeholder: "placeholder",
                isClearButtonNeeded: true,
                maxNumOfChar: 10,
                regularExpression: .exceptSpecialCharSpaces)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
