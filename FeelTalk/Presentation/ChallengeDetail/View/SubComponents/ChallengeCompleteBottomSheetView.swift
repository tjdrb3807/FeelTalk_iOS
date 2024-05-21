//
//  ChallengeCompleteBottomSheetView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeCompleteBottomSheetView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var bottomSheet: UIView = {
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height - ChallengeCompleteBottomSheetViewNameSpace.bottomSheetTopInset)))
        view.backgroundColor = .white
        view.layer.cornerRadius = ChallengeCompleteBottomSheetViewNameSpace.bottomSheetCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                             cornerRadius: ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowCornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.withAlphaComponent(ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowColorAlpha).cgColor
        view.layer.shadowOpacity = ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowOpacity
        view.layer.shadowRadius = ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowRadius
        view.layer.shadowOffset = CGSize(width: ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowOffsetWidth,
                                         height: ChallengeCompleteBottomSheetViewNameSpace.bottomSheetShadowOffsetHeight)
        
        return view
    }()
    
    private lazy var image: UIImageView = { UIImageView(image: UIImage(named: ChallengeCompleteBottomSheetViewNameSpace.image)) }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeCompleteBottomSheetViewNameSpace.headerLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeCompleteBottomSheetViewNameSpace.headerLabelTextSize)
        label.setLineHeight(height: ChallengeCompleteBottomSheetViewNameSpace.headerLabelLineHeight)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeCompleteBottomSheetViewNameSpace.bodyLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: ChallengeCompleteBottomSheetViewNameSpace.bodyLabelTextSize)
        label.setLineHeight(height: ChallengeCompleteBottomSheetViewNameSpace.bodyLabelLineHeight)
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(ChallengeCompleteBottomSheetViewNameSpace.confirmButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: ChallengeCompleteBottomSheetViewNameSpace.confirmButtonTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = ChallengeCompleteBottomSheetViewNameSpace.confirmButtonCornerRadius
        
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
    
    private func bind () {
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.hidden()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetSubComponents()
    }
    
    private func setConstraints() {
        makeBottomSheetConstraints()
        makeImageConstraints()
        makeHeaderLabelConstraints()
        makeBodyLabelConstraints()
        makeConfirmButtonConstraints()    }
}

extension ChallengeCompleteBottomSheetView {
    private func addViewSubComponents() { addSubview(bottomSheet) }
    
    private func addBottomSheetSubComponents() {
        [image, headerLabel, bodyLabel, confirmButton].forEach { bottomSheet.addSubview($0) }
    }
    
    private func makeBottomSheetConstraints() {
        bottomSheet.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeImageConstraints() {
        image.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeCompleteBottomSheetViewNameSpace.imageTopInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ChallengeCompleteBottomSheetViewNameSpace.imageWidth)
            $0.height.equalTo(ChallengeCompleteBottomSheetViewNameSpace.imageHeight)
        }
    }
    
    private func makeHeaderLabelConstraints() {
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeBodyLabelConstraints() {
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(ChallengeCompleteBottomSheetViewNameSpace.bodyLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeConfirmButtonConstraints() {
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(bodyLabel.snp.bottom).offset(ChallengeCompleteBottomSheetViewNameSpace.confirmButtonTopOffset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(ChallengeCompleteBottomSheetViewNameSpace.confirmButtonHeight)
        }
    }
}

extension ChallengeCompleteBottomSheetView {
    func show() {
        bottomSheet.snp.updateConstraints { $0.top.equalToSuperview().inset(ChallengeCompleteBottomSheetViewNameSpace.bottomSheetTopInset) }
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        },
        completion: nil)
    }
    
    func hidden() {
        bottomSheet.snp.updateConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) { [weak self] in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        },
        completion: nil)
    }
}

#if DEBUG

import SwiftUI

struct ChallengeCompleteBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCompleteBottomSheetView_Presentable()
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct ChallengeCompleteBottomSheetView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeCompleteBottomSheetView()
            v.show()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
