//
//  AdultAuthNumberDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthNumberDesciptionView: UIView {
    let descriptionState = PublishRelay<AdultAuthNumberDescription>()
    let expiradTime = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = AdultAuthNumberDescriptionViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthNumberDescriptionViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = AdultAuthNumberDescriptionViewNameSpace.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var timerView: AdultAuthTimerView = {
        let view = AdultAuthTimerView()
        view.isHidden = true
        
        return view
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
        descriptionState
            .map {
                $0 == .base ?
                (text: $0.rawValue, color: UIColor(named: CommonColorNameSpace.gray500)) :
                (text: $0.rawValue, color: UIColor.red)
            }.withUnretained(self)
            .bind { v, event in
                v.descriptionLabel.rx.text.onNext(event.text)
                v.descriptionLabel.rx.textColor.onNext(event.color)
                v.descriptionLabel.setLineHeight(height: AdultAuthNumberDescriptionViewNameSpace.desctiptionLabelLineHeight)
            }.disposed(by: disposeBag)
        
        expiradTime
            .bind(to: timerView.expiradTime)
            .disposed(by: disposeBag)
        
        expiradTime
            .take(1)
            .withUnretained(self)
            .bind { v, _ in
                v.timerView.rx.isHidden.onNext(false)
            }.disposed(by: disposeBag)
        
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeTimerViewConstraints()
    }
}

extension AdultAuthNumberDesciptionView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(AdultAuthNumberDescriptionViewNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(AdultAuthNumberDescriptionViewNameSpace.contentStackViewTrailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [descriptionLabel, timerView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTimerViewConstraints() {
        timerView.snp.makeConstraints {
            $0.width.equalTo(AdultAuthTimerViewNameSpace.width)
            $0.height.equalTo(AdultAuthTimerViewNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthNumberDesciptionView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthNumberDesciptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: CommonConstraintNameSpace.verticalRatioCalculator * 4.43,
                   alignment: .center)
    }
    
    struct AdultAuthNumberDesciptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthNumberDesciptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
