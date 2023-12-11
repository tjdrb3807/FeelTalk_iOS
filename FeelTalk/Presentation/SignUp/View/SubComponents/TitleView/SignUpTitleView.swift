//
//  SignUpTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpTitleView: UIView {
    /// 성인인증 성공 여부
    let adultAuthenticated = PublishRelay<AdultAuthStatus>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: SignUpTitleViewNameSpace.titleLabelTextSize)
        label.numberOfLines = SignUpTitleViewNameSpace.titleLabelNumberOfLines
        label.backgroundColor = .clear
        
        return label
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
        adultAuthenticated
            .filter { $0 == .authenticated }
            .withUnretained(self)
            .bind {v, _ in
                v.titleLabel.rx.text.onNext(SignUpTitleViewNameSpace.titleLabelCertificatedText)
                v.titleLabel.setLineHeight(height: SignUpTitleViewNameSpace.titleLabelLineHeight)
            }.disposed(by: disposeBag)
        
        adultAuthenticated
            .filter { $0 == .nonAuthenticated }
            .withUnretained(self)
            .bind { v, _ in
                v.titleLabel.rx.text.onNext(SignUpTitleViewNameSpace.titleLabelDefaultText)
                v.titleLabel.setLineHeight(height: SignUpTitleViewNameSpace.titleLabelLineHeight)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() { addSubview(titleLabel) }
    
    private func setConstraints() { makeTitleLabelConstraints() }
}

extension SignUpTitleView {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
}

#if DEBUG

import SwiftUI

struct SignUpTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTitleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: SignUpTitleViewNameSpace.height,
                   alignment: .center)
    }
    
    struct SignUpTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SignUpTitleView()
            v.adultAuthenticated.accept(AdultAuthStatus.nonAuthenticated)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}


#endif

