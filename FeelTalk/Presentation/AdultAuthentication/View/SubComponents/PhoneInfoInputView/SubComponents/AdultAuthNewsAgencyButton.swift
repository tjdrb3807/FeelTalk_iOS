//
//  AdultAuthNewsAgencyButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthNewsAgencyButton: UIButton {
    let isEditing = BehaviorRelay<Bool>(value: false)
    let selectedNewsAgency = PublishRelay<NewsAgencyType>()
    private let disposeBag = DisposeBag()
    
    lazy var newsAgencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthNewsAgencyButtonNameSpace.newsAgencyLabelTextSize)
        
        return label
    }()
    
    private lazy var arrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: AdultAuthNewsAgencyButtonNameSpace.arrowIconImage))
        imageView.backgroundColor = .clear
        
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
        isEditing
            .withUnretained(self)
            .bind { v, state in
                v.updateBorder(with: state)
            }.disposed(by: disposeBag)
        
        selectedNewsAgency
            .map { type -> String in
                switch type {
                    
                case .skt:
                    return "SKT"
                case .kt:
                    return "KT"
                case .lg:
                    return "LG U+"
                case .sktThrifty:
                    return "STK 알뜰폰"
                case .ktThrifty:
                    return "KT 알뜰폰"
                case .lgThrifty:
                    return "LG 알뜰폰"
                }
            }.withUnretained(self)
            .bind { v, text in
                v.newsAgencyLabel.rx.text.onNext(text)
                v.isEditing.accept(false)
            }.disposed(by: disposeBag)
        
        rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.isEditing.accept(true)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        layer.cornerRadius = AdultAuthNewsAgencyButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() {
        makeNewsAgencyLabelConstraints()
        makeArrowIconConstraints()
    }
    
    func rotation() {
        UIView.animate(withDuration: 0.8) { [weak self] in
            guard let self = self else { return }
            
            let rotate = CGAffineTransform(rotationAngle: .pi)
            arrowIcon.transform = rotate
        } completion: { [weak self] result in
            guard let self = self else { return }
            
            let rotate = CGAffineTransform(rotationAngle: .pi)
            arrowIcon.transform = rotate
        }
    }
}

extension AdultAuthNewsAgencyButton {
    private func addViewSubComponents() {
        [newsAgencyLabel, arrowIcon].forEach { addSubview($0) }
    }
        
    private func makeNewsAgencyLabelConstraints() {
        newsAgencyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(AdultAuthNewsAgencyButtonNameSpace.newsAgencyLabelLeadingInset)
        }
    }
    
    private func makeArrowIconConstraints() {
        arrowIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(AdultAuthNewsAgencyButtonNameSpace.arrowIconTrailingInset)
            $0.width.equalTo(AdultAuthNewsAgencyButtonNameSpace.arrowIconWidth)
            $0.height.equalTo(AdultAuthNewsAgencyButtonNameSpace.arrowIconHeight)
        }
    }
    
}

extension AdultAuthNewsAgencyButton {
    private func updateBorder(with state: Bool) {
        if state {
            layer.rx.borderWidth.onNext(AdultAuthNewsAgencyButtonNameSpace.borderWidthOfActice)
            layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor)
        } else {
            layer.rx.borderWidth.onNext(AdultAuthNewsAgencyButtonNameSpace.borderWidthOfNonActice)
            layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.gray400)?.cgColor)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthNewsAgencyButton_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthNewsAgencyButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: AdultAuthNewsAgencyButtonNameSpace.defaultWidth,
                   height: AdultAuthNewsAgencyButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthNewsAgencyButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthNewsAgencyButton()
            v.selectedNewsAgency.accept(.skt)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
