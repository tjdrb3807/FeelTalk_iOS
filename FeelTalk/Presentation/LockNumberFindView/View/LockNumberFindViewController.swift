//
//  LockNumberFindViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

enum LockNumberFindViewHiddenReasonType {
    case dismissButton
    case dimmedView
    case partnerRequestButton
}

final class LockNumberFindViewController: UIViewController {
    var viewModel: LockNumberFindViewModel!
    let hiddenReasonObserver = PublishRelay<LockNumberFindViewHiddenReasonType>()
    private let disposeBag = DisposeBag()
    
    private lazy var bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = LockNumberFindViewNameSpace.bottomSheetCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind { vc, _ in
                vc.show()
            }.disposed(by: disposeBag)
        
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: LockNumberFindViewNameSpace.dismissButtonImage),
            for: .normal)
        
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
                vc.hiddenReasonObserver.accept(.dismissButton)
            }.disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberFindViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardSemiBold,
            size: LockNumberFindViewNameSpace.titleLabelTextSize)
        label.numberOfLines = LockNumberFindViewNameSpace.titleLabelNumberOfLines
        label.setLineHeight(height: LockNumberFindViewNameSpace.titleLabelLineHeight)
        
        return label
    }()
    
    private lazy var partnerRequestButton: LockNumberFindCell = {
        let button = LockNumberFindCell(
            title: LockNumberFindCellNameSpace.titleLabelPartnerRequestTypeText,
            description: LockNumberFindCellNameSpace.descriptionLabelPartnerReqeustTypeText)
        
        button.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
                vc.hiddenReasonObserver.accept(.partnerRequestButton)
            }.disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var sendEmailButton: LockNumberFindCell = {
        LockNumberFindCell(
            title: LockNumberFindCellNameSpace.titleLabelSendEmailTypeText,
            description: LockNumberFindCellNameSpace.descriptionLabelSendEmailTypeText)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    private func bind(to viewModel: LockNumberFindViewModel) {
        let input = LockNumberFindViewModel.Input(
            partnerRequestButtonTapObserver: partnerRequestButton.rx.tap,
            sendEmailButtonTapObserver: sendEmailButton.rx.tap,
            hiddenReasonObserver: hiddenReasonObserver)
        
        let _ = viewModel.transfer(input: input)
    }
    
    private func setProperties() {
        view.backgroundColor = .black.withAlphaComponent(LockNumberFindViewNameSpace.backgroundColorAlpha)
    
        UIGestureRecognizer().delegate = self
        
        Observable
            .merge(
                view.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                    guard let self = self else { return }
                    gestureRecognizer.delegate = self
                    delegate.simultaneousRecognitionPolicy = .never
                }).asObservable(),
                bottomSheet.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                    guard let self = self else { return }
                    gestureRecognizer.delegate = self
                    delegate.simultaneousRecognitionPolicy = .never
                }).asObservable()
            ).when(.recognized)
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
                vc.hiddenReasonObserver.accept(.dimmedView)
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetSubComponents()
    }
    
    private func setConstratins() {
        makeBottomSheetConstraints()
        makeDismissButtonConstraints()
        makeTitleLabelConstraints()
        makePartnerRequestButtonConstraints()
        makeSendEmailButtonConstraints()
    }
}

extension LockNumberFindViewController {
    private func addViewSubComponents() { view.addSubview(bottomSheet) }
    
    private func makeBottomSheetConstraints() {
        bottomSheet.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomSheetSubComponents() {
        [dismissButton, titleLabel, partnerRequestButton, sendEmailButton].forEach { bottomSheet.addSubview($0) }
    }
    
    private func makeDismissButtonConstraints() {
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(LockNumberFindViewNameSpace.dismissButtonTopInset)
            $0.leading.equalToSuperview().inset(LockNumberFindViewNameSpace.dismissButtonLeadingInset)
            $0.width.equalTo(LockNumberFindViewNameSpace.dismissButtonWidth)
            $0.height.equalTo(LockNumberFindViewNameSpace.dismissButtonHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(LockNumberFindViewNameSpace.titlaLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makePartnerRequestButtonConstraints() {
        partnerRequestButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(LockNumberFindViewNameSpace.partnerRequestButtonTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(LockNumberFindCellNameSpace.height)
        }
    }
    
    private func makeSendEmailButtonConstraints() {
        sendEmailButton.snp.makeConstraints {
            $0.top.equalTo(partnerRequestButton.snp.bottom).offset(LockNumberFindViewNameSpace.sendEmailButtonTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(LockNumberFindCellNameSpace.height)
        }
    }
}

extension LockNumberFindViewController {
    private func show(completion: @escaping () -> Void = {}) {
        bottomSheet.snp.updateConstraints {
            $0.top.equalToSuperview().inset(LockNumberFindViewNameSpace.bottomSheetTopInset)
        }
        
        UIView.animate(
            withDuration: LockNumberFindViewNameSpace.bottomSheetAnimateDuration,
            delay: LockNumberFindViewNameSpace.bottomSheetAnimateDelay,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func hide(completion: @escaping () -> Void = {}) {
        bottomSheet.snp.updateConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        
        UIView.animate(
            withDuration: LockNumberFindViewNameSpace.bottomSheetAnimateDuration,
            delay: LockNumberFindViewNameSpace.bottomSheetAnimateDelay,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                view.layoutIfNeeded()
            }, completion: nil)
    }
}

extension LockNumberFindViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: bottomSheet) == false else { return false }

        return true
    }
}

#if DEBUG

import SwiftUI

struct LockNumberFindViewController_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberFindViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LockNumberFindViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = LockNumberFindViewController()
            let vm = LockNumberFindViewModel(coordinator: DefaultLockNumberFindCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
