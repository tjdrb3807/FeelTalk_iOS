//
//  SignalDialView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalDialView: UIView {
    let model = PublishRelay<Signal>()
    private let disposeBag = DisposeBag()
    
    private lazy var dialImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SignalDialViweNameSpace.dialImageViewImage)
        
        return imageView
    }()
    
    lazy var tiredPointButton: SignalDialPointButton = { SignalDialPointButton(type: .tired) }()
    
    lazy var refusePointButton: SignalDialPointButton = { SignalDialPointButton(type: .refuse) }()
    
    lazy var ambiguousPointButton: SignalDialPointButton = { SignalDialPointButton(type: .ambiguous) }()
    
    lazy var lovePointButton: SignalDialPointButton = { SignalDialPointButton(type: .love) }()
    
    lazy var sexyPointButton: SignalDialPointButton = { SignalDialPointButton(type: .sexy) }()
    
    private lazy var pointer: UIImageView = { UIImageView() }()
    
    private lazy var signalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = SignalDialViweNameSpace.signalImageViewCornerRadius
        imageView.clipsToBounds = true
        
        return imageView
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
        model
            .map { $0.type }
            .withUnretained(self)
            .bind { v, type in
                v.setSignalImageViewProperties(with: type)
                v.setPointerPropertise(with: type)
                v.updateSignalPoint(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        [dialImageView, signalImageView,
         tiredPointButton, refusePointButton, ambiguousPointButton, lovePointButton, sexyPointButton,
         pointer].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        makeDialImageViewConstraints()
        makeSignalImageViewConstraints()
        makeTiredPointButtonConstraints()
        makeRefusePointButtonConstraints()
        makeAmbiguousPointButtonConstraints()
        makeLovePointButtonConstraints()
        makeSexyPointButtonConstraints()
    }
}

extension SignalDialView {
    private func makeDialImageViewConstraints() {
        dialImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(SignalDialViweNameSpace.dialImageViewLeadingInset)
            $0.trailing.equalToSuperview().inset(SignalDialViweNameSpace.trailingInset)
            $0.bottom.equalToSuperview().inset(SignalDialViweNameSpace.dialImageViewBottomInset)
        }
    }
    
    private func makeSignalImageViewConstraints() {
        signalImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SignalDialViweNameSpace.signalImageViewWidth)
            $0.height.equalTo(SignalDialViweNameSpace.signalImageViewHeight)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeTiredPointButtonConstraints() {
        tiredPointButton.snp.makeConstraints {
            $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialPointButtonNameSpace.zeroTypeLeadingOffset)
            $0.bottom.equalTo(dialImageView.snp.bottom).offset(SignalDialPointButtonNameSpace.zeroTypeBottomOffset)
            $0.width.equalTo(SignalDialPointButtonNameSpace.width)
            $0.height.equalTo(SignalDialPointButtonNameSpace.height)
        }
    }
    
    private func makeRefusePointButtonConstraints() {
        refusePointButton.snp.makeConstraints {
            $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialPointButtonNameSpace.twentyTypeLeadingOffset)
            $0.bottom.equalTo(dialImageView.snp.bottom).offset(SignalDialPointButtonNameSpace.twentyTypeBottomOffset)
            $0.width.equalTo(SignalDialPointButtonNameSpace.width)
            $0.height.equalTo(SignalDialPointButtonNameSpace.height)
        }
    }
    
    private func makeAmbiguousPointButtonConstraints() {
        ambiguousPointButton.snp.makeConstraints {
            $0.top.equalTo(dialImageView.snp.top).offset(SignalDialPointButtonNameSpace.fiftyTypeTopOffset)
            $0.centerX.equalTo(dialImageView.snp.centerX)
            $0.width.equalTo(SignalDialPointButtonNameSpace.width)
            $0.height.equalTo(SignalDialPointButtonNameSpace.height)
        }
    }
    
    private func makeLovePointButtonConstraints() {
        lovePointButton.snp.makeConstraints {
            $0.trailing.equalTo(dialImageView.snp.trailing).offset(SignalDialPointButtonNameSpace.seventyFiveTypeTrailingOffset)
            $0.bottom.equalTo(dialImageView.snp.bottom).offset(SignalDialPointButtonNameSpace.seventyFiveTypeBottomOffset)
            $0.width.equalTo(SignalDialPointButtonNameSpace.width)
            $0.height.equalTo(SignalDialPointButtonNameSpace.height)
        }
    }
    
    private func makeSexyPointButtonConstraints() {
        sexyPointButton.snp.makeConstraints {
            $0.trailing.equalTo(dialImageView.snp.trailing).offset(SignalDialPointButtonNameSpace.hundredTypeTrailingOffset)
            $0.bottom.equalTo(dialImageView.snp.bottom).offset(SignalDialPointButtonNameSpace.hundredTypeBottomOffset)
            $0.width.equalTo(SignalDialPointButtonNameSpace.width)
            $0.height.equalTo(SignalDialPointButtonNameSpace.height)
        }
    }
}

extension SignalDialView {
    private func setSignalImageViewProperties(with model: SignalType) {
        switch model {
        case .sexy:
            signalImageView.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.siganlImageViewSexyTypeImage))
        case .love:
            signalImageView.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.siganlImageViewLoveTypeImage))
        case .ambiguous:
            signalImageView.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.siganlImageViewAmbiguousTypeImage))
        case .refuse:
            signalImageView.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.siganlImageViewRefuseTypeImage))
        case .tired:
            signalImageView.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.siganlImageViewTiredTypeImage))
        }
    }
    
    private func setPointerPropertise(with model: SignalType) {
        switch model {
        case .sexy:
            pointer.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.pointerSexyTypeImage))
            pointer.snp.remakeConstraints {
                $0.top.equalTo(dialImageView.snp.top).offset(SignalDialViweNameSpace.pointerSexyTypeTopOffset)
                $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialViweNameSpace.pointerSexyTypeLeadingOffset)
                $0.width.equalTo(SignalDialViweNameSpace.pointerWidth)
                $0.height.equalTo(SignalDialViweNameSpace.pointerHeight)
            }
        case .love:
            pointer.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.pointerLoveTypeImage))
            pointer.snp.remakeConstraints {
                $0.top.equalTo(dialImageView.snp.top).offset(SignalDialViweNameSpace.pointerLoveTypeTopOffset)
                $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialViweNameSpace.pointerLoveTypeLeadingOffset)
                $0.width.equalTo(SignalDialViweNameSpace.pointerWidth)
                $0.height.equalTo(SignalDialViweNameSpace.pointerHeight)
            }
        case .ambiguous:
            pointer.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.pointerAmbiguousTypeImage))
            pointer.snp.remakeConstraints {
                $0.top.equalTo(dialImageView.snp.top).offset(SignalDialViweNameSpace.pointerAmbiguousTypeTopOffset)
                $0.centerX.equalTo(dialImageView.snp.centerX)
                $0.width.equalTo(SignalDialViweNameSpace.pointerWidth)
                $0.height.equalTo(SignalDialViweNameSpace.pointerHeight)
            }
        case .refuse:
            pointer.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.pointerRefuseTypeImage))
            pointer.snp.remakeConstraints {
                $0.top.equalTo(dialImageView.snp.top).offset(SignalDialViweNameSpace.pointerRefuseTypeTopOffset)
                $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialViweNameSpace.pointerRefuseTypeLeadingOffset)
                $0.width.equalTo(SignalDialViweNameSpace.pointerWidth)
                $0.height.equalTo(SignalDialViweNameSpace.pointerHeight)
            }
        case .tired:
            pointer.rx.image.onNext(UIImage(named: SignalDialViweNameSpace.pointerTiredTypeImage))
            pointer.snp.remakeConstraints {
                $0.top.equalTo(dialImageView.snp.top).offset(SignalDialViweNameSpace.pointerTiredTypeTopOffset)
                $0.leading.equalTo(dialImageView.snp.leading).offset(SignalDialViweNameSpace.pointerTiredTypeLeadingOffset)
                $0.width.equalTo(SignalDialViweNameSpace.pointerWidth)
                $0.height.equalTo(SignalDialViweNameSpace.pointerHeight)
            }
        }
    }
    
    private func updateSignalPoint(with type: SignalType) {
        switch type {
        case .sexy:
            sexyPointButton.isSelected(true)
            lovePointButton.isSelected(false)
            ambiguousPointButton.isSelected(false)
            refusePointButton.isSelected(false)
            tiredPointButton.isSelected(false)
        case .love:
            sexyPointButton.isSelected(false)
            lovePointButton.isSelected(true)
            ambiguousPointButton.isSelected(false)
            refusePointButton.isSelected(false)
            tiredPointButton.isSelected(false)
        case .ambiguous:
            sexyPointButton.isSelected(false)
            lovePointButton.isSelected(false)
            ambiguousPointButton.isSelected(true)
            refusePointButton.isSelected(false)
            tiredPointButton.isSelected(false)
        case .refuse:
            sexyPointButton.isSelected(false)
            lovePointButton.isSelected(false)
            ambiguousPointButton.isSelected(false)
            refusePointButton.isSelected(true)
            tiredPointButton.isSelected(false)
        case .tired:
            sexyPointButton.isSelected(false)
            lovePointButton.isSelected(false)
            ambiguousPointButton.isSelected(false)
            refusePointButton.isSelected(false)
            tiredPointButton.isSelected(true)
        }
    }
}

#if DEBUG

import SwiftUI

struct SignalDialView_Previews: PreviewProvider {
    static var previews: some View {
        SignalDialView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: SignalDialViweNameSpace.height,
                   alignment: .center)
    }
    
    struct SignalDialView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignalDialView()
            v.model.accept(.init(type: .refuse))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
