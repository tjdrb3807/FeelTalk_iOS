//
//  HomeBottomSheetView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class HomeBottomSheetView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var bottomSheet: UIView = {
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height - HomeBottomSheetViewNameSpace.bottomSheetTopInset)))
        view.backgroundColor = .white
        view.layer.cornerRadius = HomeBottomSheetViewNameSpace.bottomSheetCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                             cornerRadius: HomeBottomSheetViewNameSpace.bottomSheetCornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.withAlphaComponent(HomeBottomSheetViewNameSpace.bottomSheetShadowColorAlpha).cgColor
        view.layer.shadowOpacity = HomeBottomSheetViewNameSpace.bottomSheetShadowOpacity
        view.layer.shadowRadius = HomeBottomSheetViewNameSpace.bottomSheetCornerRadius
        view.layer.shadowOffset = CGSize(width: HomeBottomSheetViewNameSpace.bottomSheetOffsetWidth,
                                         height: HomeBottomSheetViewNameSpace.bottomSheetOffsetHeight)
        
        return view
    }()
    
    private lazy var titleImageView: UIImageView = { UIImageView(image: UIImage(named: HomeBottomSheetViewNameSpace.titleImageViewImage)) }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = HomeBottomSheetViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: HomeBottomSheetViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = HomeBottomSheetViewNameSpace.descriptionLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: HomeBottomSheetViewNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(HomeBottomSheetViewNameSpace.confirmButtonTitleText,
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: HomeBottomSheetViewNameSpace.confirmButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = HomeBottomSheetViewNameSpace.confirmButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge(
                self.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
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
            .bind { v, _ in
                v.isHidden(true)
            }.disposed(by: disposeBag)
        
        bottomSheet.rx.panGesture()
            .withUnretained(self)
            .bind { v, gesture in
                let transition = gesture.translation(in: v.bottomSheet)
                
                guard transition.y > HomeBottomSheetViewNameSpace.bottomSheetTopPanGesturePrevnetionNumber else { return }
                
                switch gesture.state {
                case .changed:
                    v.bottomSheet.snp.updateConstraints { $0.top.equalToSuperview().inset(HomeBottomSheetViewNameSpace.bottomSheetTopInset + transition.y) }
                case .ended:
                    if (transition.y < v.bottomSheet.bounds.height / HomeBottomSheetViewNameSpace.bottomSheetHiddenStateLocation) {
                        v.isHidden(false)
                    } else {
                        v.isHidden(true)
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind { v, _ in
                v.isHidden(true)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetSubComponents()
    }
    
    private func setConstratins() {
        makeBottomSheetConstraints()
        makeTitleImageViewConstraints()
        makeTitleLabelConstraints()
        makeDescriptionLabelConstraints()
        makeConfirmButtonConstraints()
    }
}

extension HomeBottomSheetView {
    private func addViewSubComponents() { addSubview(bottomSheet) }
    
    private func makeBottomSheetConstraints() {
        bottomSheet.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomSheetSubComponents() {
        [titleImageView, titleLabel, descriptionLabel, confirmButton].forEach { bottomSheet.addSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeBottomSheetViewNameSpace.titleImageViewTopInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(HomeBottomSheetViewNameSpace.titleImageViewWidth)
            $0.height.equalTo(HomeBottomSheetViewNameSpace.titleImageViewHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(HomeBottomSheetViewNameSpace.titleLabelHeight)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(HomeBottomSheetViewNameSpace.descriptionLabelTopOffset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(HomeBottomSheetViewNameSpace.descriptionLabelHeight)
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeBottomSheetViewNameSpace.confirmButtonTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(HomeBottomSheetViewNameSpace.confirmButtonHeight)
        }
    }
}

extension HomeBottomSheetView {
    func isHidden(_ state: Bool) {
        if state {
            bottomSheet.snp.updateConstraints { $0.top.equalToSuperview().inset(UIScreen.main.bounds.height) }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + HomeBottomSheetViewNameSpace.bottomSheetAnimateDuration) { [weak self] in
                guard let self = self else { return }
                self.removeFromSuperview()
            }
            

        } else {
            bottomSheet.snp.updateConstraints { $0.top.equalToSuperview().inset(HomeBottomSheetViewNameSpace.bottomSheetTopInset) }
        }
        
        UIView.animate(
            withDuration: HomeBottomSheetViewNameSpace.bottomSheetAnimateDuration,
            delay: HomeBottomSheetViewNameSpace.bottomSheetAnimateDelay,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded() },
            completion: nil)
    }
}

extension HomeBottomSheetView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.bottomSheet) == false else { return false }
        
        return true
    }
}

#if DEBUG

import SwiftUI

struct HomeBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBottomSheetView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct HomeBottomSheetView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeBottomSheetView()
            v.isHidden(false)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
