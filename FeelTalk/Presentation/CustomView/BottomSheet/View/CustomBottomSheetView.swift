//
//  CustomBottomSheetView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomBottomSheetView: UIView {
    let type = PublishRelay<CustomBottomSheetType>()
    private let disposeBag = DisposeBag()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = CustomBottomSheetViewNameSpcae.bottomSheetViewCornerRadius
        view.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero,
                                                                 size: CGSize(width: UIScreen.main.bounds.width,
                                                                              height: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowPathHeight)),
                                             cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor(red: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowColorRed,
                                         green: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowColorGreen,
                                         blue: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowColorBlue,
                                         alpha: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowColorAlpha).cgColor
        view.layer.shadowOffset = CGSize(width: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowOffsetWidth,
                                         height: CustomBottomSheetViewNameSpcae.bottomSheetViewShadowOffsetHeight)
        view.layer.shadowRadius = CustomBottomSheetViewNameSpcae.bottomSheetViewShadowRadius
        view.layer.shadowOpacity = CustomBottomSheetViewNameSpcae.bottomSheetViewShadowOpacity
        
        return view
    }()
    
    private lazy var bottomSheetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = CustomBottomSheetViewNameSpcae.bottomSheetStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = CustomBottomSheetViewNameSpcae.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: CustomBottomSheetViewNameSpcae.titleLabelTextSize)
        label.numberOfLines = CustomBottomSheetViewNameSpcae.titleLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: CustomBottomSheetViewNameSpcae.descriptionLabelTextSize)
        label.numberOfLines = CustomBottomSheetViewNameSpcae.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(CustomBottomSheetViewNameSpcae.confirmButtonTitleText,
                        for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: CustomBottomSheetViewNameSpcae.confirmButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = CustomBottomSheetViewNameSpcae.confirmButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        type
            .withUnretained(self)
            .bind { v, type in
                v.setTitleLabelProperties(with: type)
                v.setImageViewProperties(with: type)
                v.setDescriptionLableProperties(with: type)
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.hide()
            }.disposed(by: disposeBag)
        
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { v, tap in
                v.hide()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetViewSubComponents()
        addBottomSheetStackViewSubComponents()
        addContentSackViewSubComponents()
    }
    
    private func setConstraints() {
        makeDimmedViewConstraints()
        makeBottomSheetViewConstraints()
        makeBottomSheetStackViewConstraints()
        makeTitleLableConstraints()
        makeImageViewConstraints()
        makeConfirmButtonConstraints()
    }
}

extension CustomBottomSheetView {
    private func addViewSubComponents() {
        [dimmedView, bottomSheetView].forEach { addSubview($0) }
    }
    
    private func makeDimmedViewConstraints() {
        dimmedView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomSheetViewSubComponents() {
        bottomSheetView.addSubview(bottomSheetStackView)
    }
    
    private func makeBottomSheetStackViewConstraints() {
        bottomSheetStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(CustomBottomSheetViewNameSpcae.bottomSheetStackViewTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
    
    private func addBottomSheetStackViewSubComponents() {
        [contentStackView, confirmButton].forEach { bottomSheetStackView.addArrangedSubview($0) }
    }
    
    private func addContentSackViewSubComponents() {
        [titleLabel, imageView, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleLableConstraints() {
        titleLabel.snp.makeConstraints { $0.height.equalTo(CustomBottomSheetViewNameSpcae.titleLableHeight) }
    }
    
    private func makeImageViewConstraints() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(CustomBottomSheetViewNameSpcae.imageViewWidth)
            $0.height.equalTo(CustomBottomSheetViewNameSpcae.imageViewHeight)
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(CustomBottomSheetViewNameSpcae.confirmButtonHeight)
            $0.width.equalToSuperview()
        }
    }
}

extension CustomBottomSheetView {
    private func setTitleLabelProperties(with type: CustomBottomSheetType) {
        switch type {
        case .inquiry:
            titleLabel.rx.text.onNext(CustomBottomSheetViewNameSpcae.titleLabelInquiryTypeText)
        case .suggestions:
            titleLabel.rx.text.onNext(CustomBottomSheetViewNameSpcae.titleLabelSuggestionTypeText)
        }
        
        titleLabel.setLineHeight(height: CustomBottomSheetViewNameSpcae.titleLableLineHeight)
        titleLabel.textAlignment = .center
    }
    
    private func setImageViewProperties(with type: CustomBottomSheetType) {
        switch type {
        case .inquiry:
            imageView.rx.image.onNext(UIImage(named: CustomBottomSheetViewNameSpcae.imageViewInquiryTypeImage))
        case .suggestions:
            imageView.rx.image.onNext(UIImage(named: CustomBottomSheetViewNameSpcae.imageViewSuggestionTypeImage))
        }
    }
    
    private func setDescriptionLableProperties(with type: CustomBottomSheetType) {
        switch type {
        case .inquiry:
            descriptionLabel.rx.text.onNext(CustomBottomSheetViewNameSpcae.descriptionLabelInquiryTypeText)
            descriptionLabel.snp.remakeConstraints { $0.height.equalTo(CustomBottomSheetViewNameSpcae.descriptionLabelInquiryTypeHeight)}
        case .suggestions:
            descriptionLabel.rx.text.onNext(CustomBottomSheetViewNameSpcae.descriptionLabelSuggestionTypeText)
            descriptionLabel.snp.remakeConstraints { $0.height.equalTo(CustomBottomSheetViewNameSpcae.dascriotionLabelSuggestionTypeHeight)}
        }
        
        descriptionLabel.setLineHeight(height: CustomBottomSheetViewNameSpcae.descriptionLabelLineHeight)
        descriptionLabel.textAlignment = .center
    }
}

// MARK: Animation
extension CustomBottomSheetView {
    public func show(completion: @escaping () -> Void = {}, type: CustomBottomSheetType) {
        switch type {
        case .inquiry:
            bottomSheetView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(CustomBottomSheetViewNameSpcae.bottomSheetViewInquiryTypeTopInset)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        case .suggestions:
            bottomSheetView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(CustomBottomSheetViewNameSpcae.bottomSheetViewSuggestionTypeTopInset)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        UIView.animate(
            withDuration: CustomBottomSheetViewNameSpcae.showAnimateDuration,
            delay: CustomBottomSheetViewNameSpcae.showAnimateDelay,
            options: .curveEaseIn,
            animations: { self.layoutIfNeeded() },
            completion: nil
        )
    }
    
    public func hide(completion: @escaping () -> Void = {}) {
        bottomSheetView.snp.remakeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        UIView.animate(
            withDuration: CustomBottomSheetViewNameSpcae.hideAnimateDuration,
            delay: CustomBottomSheetViewNameSpcae.hideAnimateDelay,
            options: .curveEaseIn,
            animations: { self.layoutIfNeeded() },
            completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CustomBottomSheetViewNameSpcae.removeFromSuperviewDelay) {
            self.removeFromSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomBottomSheetView_PreViews: PreviewProvider {
    static var  previews: some View {
        CustomBottomSheetView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct CustomBottomSheetView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = CustomBottomSheetView()
            view.type.accept(.suggestions)
            view.show(type: .suggestions)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
