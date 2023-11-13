//
//  ChallengeTabBarItem.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class ChallengeTabBarItem: UIView {
    let model = PublishRelay<ChallengeTabBarModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeTabBarItemNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeTabBarItemNameSpace.titleLabelFontSize)
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChallengeTabBarItemNameSpace.countLabelFontSize)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.titleLabel.rx.text.onNext(model.type.rawValue)
                v.countLabel.rx.text.onNext(String(model.count))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = UIColor(named: CommonColorNameSpace.gray100) }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStakcViewConstraints()
    }
}

extension ChallengeTabBarItem {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStakcViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel, countLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension ChallengeTabBarItem {
//    private func setTitleLabelProperties(with type: ChallengeTabBarItemType) {
//        switch type {
//        case .onGoing:
//            <#code#>
//        case .completed:
//            <#code#>
//        }
//    }
}

#if DEBUG

import SwiftUI

struct ChallengeTabBarItem_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTabBarItem_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width / 2,
                   height: 48,
                   alignment: .center)
    }
    
    struct ChallengeTabBarItem_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeTabBarItem()
            v.model.accept(.init(type: .onGoing, count: 999))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
