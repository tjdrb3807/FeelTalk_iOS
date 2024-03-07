//
//  LockNumberHintAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum LockNumberHintAnswerWarningType: String {
    case exceedingLetters = "최대 10글자까지 입력할 수 있어요"
    case useSpecialCharOfSpace = "특수문자, 공백은 사용할 수 없어요"
    case none
}

final class LockNumberHintAnswerView: UIStackView {
    let selectedHintObserver = PublishRelay<LockNumberHintType>()
    let crtInputViewObserver = PublishRelay<CustomTextField03>()
    let dateObserver = BehaviorRelay<Date>(value: Date())
    let textObserver = PublishRelay<String>()
    let toolBarButtonTapObserver = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberHintAnswerViewNameSpace.contentStackViewSpacing
        
        selectedHintObserver
            .take(1)
            .asObservable()
            .withUnretained(self)
            .bind { v, type in
                var inputView: CustomTextField03
                
                switch type {
                case .date:
                    inputView = v.setUpDateInputView()
                default:
                    inputView = v.setUpTextInputView()
                }
                
                stackView.insertArrangedSubview(inputView, at: LockNumberHintAnswerViewNameSpace.inputViewIndex)
                
                inputView.snp.makeConstraints { $0.width.equalToSuperview() }
                v.crtInputViewObserver.accept(inputView)
            }.disposed(by: disposeBag)

        selectedHintObserver
            .skip(1)
            .asObservable()
            .withUnretained(self)
            .bind { v, type in
                guard let crtInputView = stackView.arrangedSubviews[LockNumberHintAnswerViewNameSpace.inputViewIndex] as? CustomTextField03 else { return }
                stackView.removeArrangedSubview(crtInputView)
                crtInputView.removeFromSuperview()
                
                var newInputView: CustomTextField03
            
                switch type {
                case .date:
                    newInputView = v.setUpDateInputView()
                default:
                    newInputView = v.setUpTextInputView()
                }
                
                stackView.insertArrangedSubview(newInputView, at: LockNumberHintAnswerViewNameSpace.inputViewIndex)
                
                newInputView.snp.makeConstraints { $0.width.equalToSuperview() }
                v.crtInputViewObserver.accept(newInputView)
            }.disposed(by: disposeBag)
        
        return stackView
    }()
    
    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .myAnswer, isRequiredInput: false) }()
    
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
        spacing = LockNumberHintAnswerViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeInputTitleViewConstraints()
    }
}

extension LockNumberHintAnswerView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [inputViewTitle].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeInputTitleViewConstraints() {
        inputViewTitle.snp.makeConstraints { $0.height.equalTo(LockNumberHintAnswerViewNameSpace.inputTitleViewHeight)}
    }
}

extension LockNumberHintAnswerView {
    private func setUpDateInputView() -> CustomTextField03 {
        let dateInputView = CustomTextField03(
            placeholder: nil,
            isClearButtonNeeded: false,
            maxNumOfChar: nil,
            regularExpression: nil)
        dateInputView.textField.tintColor = .clear
        
        let calenderIcon = UIImageView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: ChallengeDeadlineViewNameSpace.calenderIconWidth,
                    height: ChallengeDeadlineViewNameSpace.calenderIconHeight)))
        calenderIcon.image = UIImage(named: ChallengeDeadlineViewNameSpace.calenderIconImage)
        
        dateInputView.textField.rightView = calenderIcon
        dateInputView.textField.rightViewMode = .always
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: LockNumberHintAnswerViewNameSpace.dateInputViewFormatterIdentifier)
        datePicker.rx.date.onNext(Date())
        dateInputView.textField.inputView = datePicker
        
        let toolBar = CustomToolbar(type: .completion)
        dateInputView.textField.inputAccessoryView = toolBar
        
        datePicker.rx.value
            .asObservable()
            .bind(to: dateObserver)
            .disposed(by: disposeBag)
        
        dateObserver
            .asObservable()
            .map { date -> String in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: LockNumberHintAnswerViewNameSpace.dateInputViewFormatterIdentifier)
                formatter.dateFormat = LockNumberHintAnswerViewNameSpace.dateInputViewFormatter
                
                return formatter.string(from: date)
            }.bind(to: dateInputView.textField.rx.text)
            .disposed(by: disposeBag)
        
        toolBar.rightButton.rx.tap
            .map { _ -> Void in }
            .bind(to: toolBarButtonTapObserver)
            .disposed(by: disposeBag)
        
        return dateInputView
    }
    
    private func setUpTextInputView() -> CustomTextField03 {
        let textInputView = CustomTextField03(
            placeholder: LockNumberHintAnswerViewNameSpace.textInputViewPlaceholder,
            isClearButtonNeeded: true,
            maxNumOfChar: LockNumberHintAnswerViewNameSpace.textInputViewMexCount,
            regularExpression: .exceptSpecialCharSpaces)
        let toolBar = CustomToolbar(type: .completion)
        
        textInputView.textField.inputAccessoryView = toolBar
        
        textInputView.textField
            .rx.changeText
            .orEmpty
            .asObservable()
            .bind(to: textObserver)
            .disposed(by: disposeBag)
        
        toolBar
            .rightButton.rx.tap
            .map { _ -> Void in }
            .bind(to: toolBarButtonTapObserver)
            .disposed(by: disposeBag)
        
        return textInputView
    }
}

#if DEBUG

import SwiftUI

struct LockNumberHintAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberHintAnswerView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: LockNumberHintAnswerViewNameSpace.height,
                   alignment: .center)
    }
    
    struct LockNumberHintAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = LockNumberHintAnswerView()
            v.selectedHintObserver.accept(.treasure)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
