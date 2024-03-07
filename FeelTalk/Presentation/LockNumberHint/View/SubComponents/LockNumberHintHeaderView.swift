//
//  LockNumberHintHeaderView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNumberHintHeaderView: UIStackView {
    let viewTypeObserver = PublishRelay<LockNumberHintViewType>()
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = LockNumberHintHeaderViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: LockNumberHintHeaderViewNameSpace.titleLabelTextSize)
        label.numberOfLines = LockNumberHintHeaderViewNameSpace.titleLabelNumberOfLines
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        viewTypeObserver
            .asObservable()
            .map { type -> String in
                switch type {
                case .settings:
                    return LockNumberHintHeaderViewNameSpace.titleLabelSettingsTypeText
                case .reset:
                    return LockNumberHintHeaderViewNameSpace.titleLabelResetTypeText
                }
            }.bind { text in
                label.rx.text.onNext(text)
                label.setLineHeight(height: LockNumberHintHeaderViewNameSpace.titleLabelLineHeight)
            }.disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LockNumberHintHeaderViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LockNumberHintHeaderViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = LockNumberHintHeaderViewNameSpace.descriptionLabelNumberOfLines
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setLineHeight(height: LockNumberHintHeaderViewNameSpace.descriptionLabelLineHeight)
        
        viewTypeObserver
            .asObservable()
            .map { type -> Bool in type == .reset ? true : false }
            .bind(to: label.rx.isHidden)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = LockNumberHintHeaderViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTopSpacingConstraints()
    }
}

extension LockNumberHintHeaderView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [topSpacing, titleLabel, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTopSpacingConstraints() {
        topSpacing.snp.makeConstraints { $0.height.equalTo(LockNumberHintHeaderViewNameSpace.topSpacingHeight) }
    }
}

#if DEBUG

import SwiftUI

struct LockNumberHintHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LockNumberHintHeaderView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct LockNumberHintHeaderView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = LockNumberHintHeaderView()
            v.viewTypeObserver.accept(.settings)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
