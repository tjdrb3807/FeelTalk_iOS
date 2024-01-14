//
//  AdultAuthPhoneInfoInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthPhoneInfoInputView: UIStackView {
    let selectedNewsAgency = PublishRelay<NewsAgencyType>()
    private let disposeBag = DisposeBag()
    
    lazy var newsAgencyButton: AdultAuthNewsAgencyButton = { AdultAuthNewsAgencyButton() }()
    
    lazy var phoneNumberInputView: CustomTextField = {
        let view = CustomTextField(placeholder: AdultAuthPhoneInfoInputViewNameSpace.phoneNumberInputViewPlaceholder)
        view.keyboardType = .numberPad
        
        view.inputAccessoryView = phoneNumberInputAccessoryView
        
        return view
    }()
    
    lazy var phoneNumberInputAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConsetraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        selectedNewsAgency
            .withUnretained(self)
            .bind { v, type in
                v.newsAgencyButton.selectedNewsAgency.accept(type)
            }.disposed(by: disposeBag)
        
        selectedNewsAgency
            .skip(1)
            .withUnretained(self)
            .bind { v, type in
                v.updateNewsAgencyButtonsConstraints(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = AdultAuthPhoneInfoInputViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConsetraints() {
        makeNewsAgencyButtonConstraints()
    }
}

extension AdultAuthPhoneInfoInputView {
    private func addViewSubComponents() {
        [newsAgencyButton, phoneNumberInputView].forEach { addArrangedSubview($0) }
    }
    
    private func makeNewsAgencyButtonConstraints() {
        newsAgencyButton.snp.makeConstraints {
            $0.width.equalTo(AdultAuthNewsAgencyButtonNameSpace.defaultWidth)
        }
    }
}

extension AdultAuthPhoneInfoInputView {
    private func updateNewsAgencyButtonsConstraints(with type: NewsAgencyType) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
            switch type {
            case .skt, .kt, .lg:
                self.newsAgencyButton.snp.updateConstraints {
                    $0.width.equalTo(AdultAuthNewsAgencyButtonNameSpace.defaultWidth)
                }
            default:
                self.newsAgencyButton.snp.updateConstraints {
                    $0.width.equalTo(AdultAuthNewsAgencyButtonNameSpace.thriftyTypeWidht)
                }
            }
            self.layoutIfNeeded()
        })
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthPhoneInfoInputView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthPhoneInfoInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthPhoneInfoInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthPhoneInfoInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthPhoneInfoInputView()
            v.selectedNewsAgency.accept(.sktThrifty)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
