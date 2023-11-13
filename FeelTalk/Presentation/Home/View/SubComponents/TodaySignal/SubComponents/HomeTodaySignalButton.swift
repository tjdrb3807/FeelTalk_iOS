//
//  HomeTodaySignalButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeTodaySignalButton: UIButton {
    let type: TodaySignalButtonType
    let model = PublishRelay<Signal>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = HomeTodaySignalButtonNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var signalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = HomeTodaySignalButtonNameSpace.signalImageViewCornerRadius
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: HomeTodaySignalButtonNameSpace.targetLabelTextSize)
        label.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        label.layer.cornerRadius = HomeTodaySignalButtonNameSpace.targetLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    init(type: TodaySignalButtonType) {
        self.type = type
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: HomeTodaySignalButtonNameSpace.width,
                                              height: HomeTodaySignalButtonNameSpace.height)))
        
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
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.cornerRadius = HomeTodaySignalButtonNameSpace.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: HomeTodaySignalButtonNameSpace.cornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(HomeTodaySignalButtonNameSpace.shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: HomeTodaySignalButtonNameSpace.shadowOffsetWidth,
                                    height: HomeTodaySignalButtonNameSpace.shadowOffsetHeight)
        layer.shadowOpacity = HomeTodaySignalButtonNameSpace.shadowOpacity
        layer.shadowRadius = HomeTodaySignalButtonNameSpace.shadowRadius
        
        type == .my ? (isEnabled = true) : (isEnabled = false)
    }
    
    private func addSubComponents() {
        addButtonSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeSignalImageViewConstraints()
        makeTargetLabelConstraints()
    }
}

extension HomeTodaySignalButton {
    private func addButtonSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodaySignalButtonNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(HomeTodaySignalButtonNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(HomeTodaySignalButtonNameSpace.contentStackViewTrailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [signalImageView, targetLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeSignalImageViewConstraints() {
        signalImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(HomeTodaySignalButtonNameSpace.signalImageViewHeight)
        }
    }
    
    private func makeTargetLabelConstraints() {
        if type == .my {
            targetLabel.snp.makeConstraints {
                $0.width.equalTo(HomeTodaySignalButtonNameSpace.targetLabelMyTypeWidth)
                $0.height.equalTo(HomeTodaySignalButtonNameSpace.targetLabelHeight)
            }
        } else if type == .partner {
            targetLabel.snp.makeConstraints {
                $0.width.equalTo(HomeTodaySignalButtonNameSpace.targetLabelPartnerTypeWidth)
                $0.height.equalTo(HomeTodaySignalButtonNameSpace.targetLabelHeight)
            }
        }
    }
}

extension HomeTodaySignalButton {
    private func setSignalImageViewProperties(with type: SignalType) {
        switch type {
        case .sexy:
            signalImageView.rx.image.onNext(UIImage(named: HomeTodaySignalButtonNameSpace.signalImageViewSexyTypeImage))
        case .love:
            signalImageView.rx.image.onNext(UIImage(named: HomeTodaySignalButtonNameSpace.signalImageViewLoveTypeImage))
        case .ambiguous:
            signalImageView.rx.image.onNext(UIImage(named: HomeTodaySignalButtonNameSpace.signalImageViewAmbiguousTypeImage))
        case .refuse:
            signalImageView.rx.image.onNext(UIImage(named: HomeTodaySignalButtonNameSpace.signalImageViewRefuseTypeImage))
        case .tired:
            signalImageView.rx.image.onNext(UIImage(named: HomeTodaySignalButtonNameSpace.signalImageViewTiredTypeImage))
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeTodaySignalButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodaySignalButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: HomeTodaySignalButtonNameSpace.width,
                   height: HomeTodaySignalButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodaySignalButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeTodaySignalButton(type: .partner)
            v.model.accept(Signal(type: .refuse))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
