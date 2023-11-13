//
//  HomeTodaySignalView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeTodaySignalView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = HomeTodaySignalViewNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: HomeTodaySignalViewNameSpace.titleLabelTextSize)
        label.setLineHeight(height: HomeTodaySignalViewNameSpace.titleLAbelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var partnerSignalButton: HomeTodaySignalButton = { HomeTodaySignalButton(type: .partner) }()
    
    lazy var mySignalButton: HomeTodaySignalButton = { HomeTodaySignalButton(type: .my) }()
    
    private lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: HomeTodaySignalViewNameSpace.heartImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var frequencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: HomeTodaySignalViewNameSpace.frequencyImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        [heartImageView, frequencyImageView, titleLabel, partnerSignalButton, mySignalButton].forEach { addSubview($0) }
    }
    
    private func setConstratins() {
        makeHeartImageViewConstratins()
        makeFrequencyImageViewConstraints()
        makeTitleLabelConstraints()
        makePartnerSignalButtonConstraints()
        makeMySignalButtonConstraints()
    }
}

extension HomeTodaySignalView {
    private func makeHeartImageViewConstratins() {
        heartImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodaySignalViewNameSpace.heartImageViewTopInset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(HomeTodaySignalViewNameSpace.heartImageViewWidth)
            $0.height.equalTo(HomeTodaySignalViewNameSpace.heartImageViewHeight)
        }
    }
    
    private func makeFrequencyImageViewConstraints() {
        frequencyImageView.snp.makeConstraints {
            $0.top.equalTo(heartImageView.snp.top).offset(HomeTodaySignalViewNameSpace.frequencyImageViewTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(HomeTodaySignalViewNameSpace.frequencyImageViewWidth)
            $0.height.equalTo(HomeTodaySignalViewNameSpace.frequencyImageViewHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
    }
    
    private func makePartnerSignalButtonConstraints() {
        partnerSignalButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodaySignalButtonNameSpace.topInset)
            $0.leading.equalToSuperview()
            $0.width.equalTo(HomeTodaySignalButtonNameSpace.width)
            $0.height.equalTo(HomeTodaySignalButtonNameSpace.height)
        }
    }
    
    private func makeMySignalButtonConstraints() {
        mySignalButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(HomeTodaySignalButtonNameSpace.topInset)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(HomeTodaySignalButtonNameSpace.width)
            $0.height.equalTo(HomeTodaySignalButtonNameSpace.height)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeTodaySignalView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodaySignalView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: HomeTodaySignalViewNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodaySignalView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeTodaySignalView()
            v.partnerSignalButton.model.accept(Signal(type: .sexy))
            v.mySignalButton.model.accept(Signal(type: .love))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
