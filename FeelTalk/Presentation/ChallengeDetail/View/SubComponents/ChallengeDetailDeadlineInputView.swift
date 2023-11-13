//
//  ChallengeDetailDeadlineInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailDeadlineInputView: UIStackView {
    
    let viewMode = PublishRelay<ChallengeDetailViewMode>()
    private let disposeBag = DisposeBag()
    
    private lazy var leftSpacingView: UIView = { UIView() }()
    
    private lazy var rightSpacingView: UIView = { UIView() }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = ChallengeDetailDeadlineInputViewNameSpace.verticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailDeadlineInputViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: ChallengeDetailDeadlineInputViewNameSpace.descriptionLabelTextColor)
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeDetailDeadlineInputViewNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: ChallengeDetailDeadlineInputViewNameSpace.descriptionLabelLineHeight)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDetailDeadlineInputViewNameSpace.stackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var deadlineTextField: UITextField = {
        let textField = UITextField()
        textField.text = dateFormat(date: Date())
        textField.textColor = .black
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: ChallengeDetailDeadlineInputViewNameSpace.deadlineTextFieldTextSize)
        textField.backgroundColor = UIColor(named: ChallengeDetailDeadlineInputViewNameSpace.deadlineTextFiedlDefaultBackgroundColor)
        textField.layer.cornerRadius = ChallengeDetailDeadlineInputViewNameSpace.deadlineTextFieldCornerRadius
        textField.layer.borderWidth = ChallengeDetailDeadlineInputViewNameSpace.deadlineTextFieldBorderWidth
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.clipsToBounds = true
        textField.tintColor = .clear
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: ChallengeDetailDeadlineInputViewNameSpace.deadlineTextFieldLeftPaddingWidth,
                                                            height: textField.frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.rightView = calenderImageView
        textField.rightViewMode = .always
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    private lazy var calenderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ChallengeDetailDeadlineInputViewNameSpace.calenderImageViewImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailDeadlineInputViewNameSpace.dDayLabelDefaultText
        label.textColor = UIColor(named: ChallengeDetailDeadlineInputViewNameSpace.dDayLabelTextColor)
        label.textAlignment = .center
        label.numberOfLines = ChallengeDetailDeadlineInputViewNameSpace.dDayLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeDetailDeadlineInputViewNameSpace.dDayLabelTextSize)
        label.backgroundColor = UIColor(named: ChallengeDetailDeadlineInputViewNameSpace.dDayLabelBackgroundColor)
        label.layer.cornerRadius = ChallengeDetailDeadlineInputViewNameSpace.dDayLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    lazy var toolbar: ChallengeDetailToolbar = { ChallengeDetailToolbar(type: .deadline) }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: ChallengeDetailDeadlineInputViewNameSpace.datePickerLocaleIdentifier)
        
        let calender = Calendar(identifier: .gregorian)
        let currenteDate = Date()
        var components = DateComponents()
        components.calendar = calender
        
        let minimumDate = calender.date(byAdding: components, to: currenteDate)
        datePicker.minimumDate = minimumDate
        
        deadlineTextField.inputView = datePicker
            
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.isDeadlineTextFieldEnable(with: mode)
            }.disposed(by: disposeBag)
        
        Observable
            .merge(deadlineTextField.rx.controlEvent(.editingDidBegin).map { true },
                   deadlineTextField.rx.controlEvent(.editingDidEnd).map { false })
            .withUnretained(self)
            .bind { v, state in
                v.deadlineTextField.updateBackgourndColor(isEditingBegin: state)
                v.deadlineTextField.updateBorderColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeDetailDeadlineInputViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addVerticalStackViewSubComponents()
        addStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeDescriptionLabelConstraints()
        makeStackViewConstraints()
        makeCalenderImageViewConstraints()
        makeDdayLabelConstraints()
    }
}

extension ChallengeDetailDeadlineInputView {
    private func addViewSubComponents() {
        [leftSpacingView, verticalStackView, rightSpacingView].forEach { addArrangedSubview($0) }
    }
    
    private func addVerticalStackViewSubComponents() {
        [descriptionLabel, stackView].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(descriptionLabel.intrinsicContentSize)}
    }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints { $0.width.equalToSuperview()}
    }
    
    private func addStackViewSubComponents() {
        [deadlineTextField, dDayLabel].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func makeCalenderImageViewConstraints() {
        calenderImageView.snp.makeConstraints {
            $0.width.equalTo(ChallengeDetailDeadlineInputViewNameSpace.calenderImageViewWidth)
            $0.height.equalTo(ChallengeDetailDeadlineInputViewNameSpace.calenderImageViewHeight)
        }
    }
    
    private func makeDdayLabelConstraints() {
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(ChallengeDetailDeadlineInputViewNameSpace.dDayLabelWidth).priority(ChallengeDetailDeadlineInputViewNameSpace.dDayLabelWidthPriority)
        }
    }
}

extension ChallengeDetailDeadlineInputView {
    private func isDeadlineTextFieldEnable(with mode: ChallengeDetailViewMode) {
        switch mode {
        case .new, .modify:
            deadlineTextField.rx.isEnabled.onNext(true)
        case .ongoing, .completed:
            deadlineTextField.rx.isEnabled.onNext(false)
        }
    }
    
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일까지"
        
        return formatter.string(from: date)
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailDeadlineInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailDeadlineInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeDetailDeadlineInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeDetailDeadlineInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailDeadlineInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
