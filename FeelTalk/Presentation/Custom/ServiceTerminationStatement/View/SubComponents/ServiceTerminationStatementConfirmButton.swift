//
//  ServiceTerminationStatementConfirmButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ServiceTerminationStatementConfirmButton: UIButton {
    let isCheck = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ServiceTerminatinoStatementConfirmButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ServiceTerminatinoStatementConfirmButtonNameSpace.descriptionLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ServiceTerminatinoStatementConfirmButtonNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isCheck
            .withUnretained(self)
            .bind { v, state in
                v.toggleChekImageView(state)
            }.disposed(by: disposeBag)
        
        self.rx.tap
            .withLatestFrom(isCheck)
            .scan(false) { lastState, newState in !lastState }
            .bind(to: isCheck)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() { backgroundColor = .clear }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeCheckImageViewConstraints()
    }
}

extension ServiceTerminationStatementConfirmButton {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ServiceTerminatinoStatementConfirmButtonNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(ServiceTerminatinoStatementConfirmButtonNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(ServiceTerminatinoStatementConfirmButtonNameSpace.contentStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(ServiceTerminatinoStatementConfirmButtonNameSpace.contentStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [checkImageView, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeCheckImageViewConstraints() {
        checkImageView.snp.makeConstraints { $0.width.equalTo(ServiceTerminatinoStatementConfirmButtonNameSpace.checkImageViewWidth) }
    }
}

extension ServiceTerminationStatementConfirmButton {
    private func toggleChekImageView(_ state: Bool) {
        state ?
        checkImageView.rx.image.onNext(UIImage(named: ServiceTerminatinoStatementConfirmButtonNameSpace.checkImageViewAbleIamge)) :
        checkImageView.rx.image.onNext(UIImage(named: ServiceTerminatinoStatementConfirmButtonNameSpace.checkImageViewDisableImage))
    }
}

#if DEBUG

import SwiftUI

struct ServiceTerminationStatementConfirmButton_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTerminationStatementConfirmButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: ServiceTerminatinoStatementConfirmButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct ServiceTerminationStatementConfirmButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ServiceTerminationStatementConfirmButton()
            view.isCheck.accept(false)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
