//
//  CustomTextField02.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum RegularExpression: String {
    /// 특수문자 띄어쓰기 제외한 정규식
    case exceptSpecialCharSpaces = "^[ㄱ-ㅎㅏ-ㅣ가-핳a-zA-Z0-9]*$"
}

final class CustomTextField02: UITextField {
    private let isFocusedObserver = PublishSubject<Bool>()
    private let isEmptyObserver = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    var countView: TextCountingView?
    
    init(placeholder: String?, isClearButtonNeeded: Bool, maxNumOfChar: Int?, regularExpression: RegularExpression?) {
        super.init(frame: .zero)
        setPlaceholder(text: placeholder, color: UIColor(named: CommonColorNameSpace.gray400) ?? .clear)
        setClearButton(isClearButtonNeeded)
        setCountView(maxNum: maxNumOfChar)
        setRegularExpression(regularExpression)
        
        self.bind()
        self.setPorperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable<Bool>
            .merge(self.rx.controlEvent(.editingDidBegin).map { _ -> Bool in true },
                   self.rx.controlEvent(.editingDidEnd).map { _ -> Bool in false }
            ).bind(to: isFocusedObserver)
            .disposed(by: disposeBag)
        
        rx.text.orEmpty
            .map { text -> Bool in text.isEmpty }
            .bind(to: isEmptyObserver)
            .disposed(by: disposeBag)
    }
    
    private func setPorperties() {
        font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                      size: CustomTextFiledNameSpace01.textSize)
        textColor = .black
        tintColor = UIColor(named: CommonColorNameSpace.main500)
        backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        
        layer.borderWidth = CustomTextFiledNameSpace01.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = CustomTextFiledNameSpace01.cornerRadius
        autocorrectionType = .no
        clipsToBounds = true
        
        let leadingSpacing = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: CustomTextFiledNameSpace01.leftPaddingViewWidth,
                    height: frame.height)))
        
        leftView = leadingSpacing
        leftViewMode = .always
    }
}

extension CustomTextField02 {
    private func setClearButton(_ isClearButtonNeeded: Bool) {
        if isClearButtonNeeded {
            setClearButton(
                with: UIImage(named: InquiryEmailInputViewNameSpace.emailInputTextFieldClearButtonImage) ?? UIImage(),
                mode: .whileEditing)
        } else {
            return
        }
        
        Observable
            .combineLatest(isFocusedObserver, isEmptyObserver) { (isFocused: $0, isEmpty: $1) }
            .withUnretained(self)
            .bind { v, event in
                if !event.isFocused {
                    v.updateCountViewConsatraints(isClearButtonHidden: true)
                } else {
                    if event.isEmpty {
                        v.updateCountViewConsatraints(isClearButtonHidden: true)
                    } else {
                        v.updateCountViewConsatraints(isClearButtonHidden: false)
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func setCountView(maxNum: Int?) {
        guard let maxNum = maxNum else { return }
        let countView = TextCountingView(denominator: maxNum)
        self.countView = countView
        
        addSubview(countView)
        
        countView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewDefaultTrailingInset)
        }
        
        rx.changedText
            .scan(text) { [weak self] prev, new -> String? in
                guard let self = self else { return prev }
                if new?.count ?? 0 > maxNum {
                    return prev
                } else {
                    return new
                }
            }.asDriver(onErrorJustReturn: "")
            .drive(rx.text)
            .disposed(by: disposeBag)
    }
}

extension CustomTextField02 {
    private func updateCountViewConsatraints(isClearButtonHidden: Bool) {
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
    
    private func setRegularExpression(_ reglarExpression: RegularExpression?) {
        rx.changedText
            .orEmpty
            .scan(text) { [weak self] prev, new -> String? in
                guard let self = self,
                      let regularExpression = reglarExpression else { return prev }
                let pattern = regularExpression.rawValue
                
                do {
                    let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    if let _ = regex.firstMatch(in: new, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, new.count)) {
                        
                        self.countView?.molecularCount.accept(new.count)
                        return new
                    }
                } catch {
                    self.countView?.molecularCount.accept(prev!.count)
                    return prev
                }
                
                self.countView?.molecularCount.accept(prev!.count)
                return prev
            }.asDriver(onErrorJustReturn: "")
            .drive(rx.text)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: CustomTextField02 {
    /// textField의 값이 변경될 때 발생하는 .editingChanged, .valueChanged가 발생할 떄 textField의 value 방출
    var changedText: ControlProperty<String?> {
        base.rx.controlProperty(
            editingEvents: [.editingChanged, .valueChanged],
            getter: { textField in textField.text },
            setter: { textField, value in
                if textField.text != value {
                    textField.text = value}
            })
    }
}

#if DEBUG

import SwiftUI

struct CustomTextField02_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField02_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width - (
                    CommonConstraintNameSpace.leadingInset +
                    CommonConstraintNameSpace.trailingInset
                ),
                height: 56.0,
                alignment: .center)
    }
    
    struct CustomTextField02_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextField02(
                placeholder: "placeholder",
                isClearButtonNeeded: true,
                maxNumOfChar: 10,
                regularExpression: .exceptSpecialCharSpaces)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
