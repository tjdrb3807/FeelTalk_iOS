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
    let deadlineObserver = PublishRelay<Date>()
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
            .withUnretained(self)
            .bind { v, type in
                v.setDeadlineInputViewProperties(with: type)
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
        
        setUpDatePicker()
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
    private func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        let calender = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calender
        
        let minimumDate = calender.date(byAdding: components, to: currentDate)
        datePicker.minimumDate = minimumDate
        
        datePicker.rx.value
            .asObservable()
            .bind(to: deadlineObserver)
            .disposed(by: disposeBag)

        deadlineInputView.inputView = datePicker
    }
    
    private func setDeadlineInputViewProperties(with type: ChallengeDetailViewType) {
        switch type {
        case .completed, .ongoing:
            deadlineInputView.rx.isEnabled.onNext(false)
        case .modify, .new:
            deadlineInputView.rx.isEnabled.onNext(true)
        }
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
            v.typeObserver.accept(.new)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
