//
//  ChallengeDeadlineView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDeadlineView: UIStackView {
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    let modelObserver = PublishRelay<String>()
    let deadlineObserver = BehaviorRelay<Date>(value: Date())
    let toolBarButtonTapObserver = PublishRelay<ChallengeDetailViewToolBarType>()
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDeadlineViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .challengeDeadline,
                                                                                   isRequiredInput: false) }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDeadlineViewNameSpace.inputStackViewSpacing
        
        return stackView
    }()
    
    lazy var deadlineInputView: CustomTextField01 = {
        let inputView = CustomTextField01(placeholder: "", useClearButton: false, textLimit: 0)
        inputView.tintColor = .clear
        
        let calenderIcon = UIImageView(frame: CGRect(origin: .zero,
                                                     size: CGSize(width: ChallengeDeadlineViewNameSpace.calenderIconWidth,
                                                                  height: ChallengeDeadlineViewNameSpace.calenderIconHeight)))
        calenderIcon.image = UIImage(named: ChallengeDeadlineViewNameSpace.calenderIconImage)
        
        inputView.rightView = calenderIcon
        inputView.rightViewMode = .always
    
        return inputView
    }()
    
    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChallengeDeadlineViewNameSpace.dDayLabelTextSize)
        label.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        label.layer.cornerRadius = ChallengeDeadlineViewNameSpace.dDayLabelCornerRadius
        label.clipsToBounds = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        typeObserver
            .map { $0 == .new || $0 == .modify ? (type: $0, isEnable: true) : (type: $0, isEnable: false) }
            .withUnretained(self)
            .bind { v, event in
                v.deadlineInputView.rx.isEnabled.onNext(event.isEnable)
                if event.type == .new { v.setUpDatePicker(selectedDate: Date()) }
                if event.isEnable { v.setUpToolBar() }
            }.disposed(by: disposeBag)
        
        modelObserver
            .withUnretained(self)
            .bind { v, model in
                let deadlineStr = String.replaceT(model)
                guard let deadline = Date.strToDate(deadlineStr) else { return }
                v.setUpDatePicker(selectedDate: deadline)
                v.deadlineObserver.accept(deadline)
            }.disposed(by: disposeBag)
        
        deadlineObserver
            .withUnretained(self)
            .bind { v, date in
                v.deadlineInputView.rx.text.onNext(Utils.formatChallengeDeadline(date))
                v.dDayLabel.rx.text.onNext(Utils.calculateDday(date))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeDeadlineViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addInputStackViewSubCompontnes()
    }
    
    private func setConstratins() {
        makeInputViewTitleConstraints()
        makeInputStackViewConstraints()
        makeDdayLabelConstraints()
    }
}

extension ChallengeDeadlineView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [inputViewTitle, inputStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeInputViewTitleConstraints() {
        inputViewTitle.snp.makeConstraints { $0.height.equalTo(ChallengeDeadlineViewNameSpace.inputViewTitleHeight) }
    }
    
    private func makeInputStackViewConstraints() {
        inputStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChallengeDeadlineViewNameSpace.inputStackViewHeight)
        }
    }
    
    private func addInputStackViewSubCompontnes() {
        [deadlineInputView, dDayLabel].forEach { inputStackView.addArrangedSubview($0) }
    }
    
    private func makeDdayLabelConstraints() {
        dDayLabel.snp.makeConstraints { $0.width.equalTo(ChallengeDeadlineViewNameSpace.dDayLabelWidth) }
    }
}

extension ChallengeDeadlineView {
    private func setUpDatePicker(selectedDate: Date) {
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        datePicker.rx.date.onNext(selectedDate)
        datePicker.rx.minimumDate.onNext(Date())
        
        datePicker.rx.value
            .asObservable()
            .bind(to: deadlineObserver)
            .disposed(by: disposeBag)

        deadlineInputView.inputView = datePicker
    }
    
    private func setUpToolBar() {
        let toolBar = CustomToolbar(type: .ongoing)
        
        toolBar.rightButton.rx.tap
            .map { .deadline }
            .bind(to: toolBarButtonTapObserver)
            .disposed(by: disposeBag)
        
        deadlineInputView.inputAccessoryView = toolBar
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDeadlineView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeDeadlineViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeDeadlineView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeDeadlineView()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
