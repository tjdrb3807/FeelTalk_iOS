//
//  PasswordConfirmViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordConfirmViewCell: UIStackView {
    let isInputed = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var circleIcon: UIView = {
        let view = UIView()
        view.layer.cornerRadius = PasswordConfirmViewCellNameSpace.circleIconCornerRadius
        
        return view
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isInputed
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, state in
                v.isCircleIconHidden(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = PasswordConfirmViewCellNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() {
        makeCircleIconConstraints()
        makeBottomBorderConstraints()
    }
}

extension PasswordConfirmViewCell {
    private func addViewSubComponents() {
        [circleIcon, bottomBorder].forEach { addArrangedSubview($0) }
    }
    
    private func makeCircleIconConstraints() {
        circleIcon.snp.makeConstraints {
            $0.width.equalTo(PasswordConfirmViewCellNameSpace.circleIconWidth)
            $0.height.equalTo(PasswordConfirmViewCellNameSpace.circleIconHeight)
        }
    }
    
    private func makeBottomBorderConstraints() {
        bottomBorder.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(PasswordConfirmViewCellNameSpace.bottomBorderHeight)
        }
    }
}

extension PasswordConfirmViewCell {
    /// 제약조건 이슈로 circleIcon background = .clear 로 hidden 효과 처리
    private func isCircleIconHidden(with state: Bool) {
        state ?
        circleIcon.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
        circleIcon.rx.backgroundColor.onNext(.clear)
    }
}

#if DEBUG

import SwiftUI

struct PasswordConfirmViewCell_Preview: PreviewProvider {
    static var previews: some View {
        PasswordConfirmViewCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: PasswordConfirmViewCellNameSpace.width,
                   height: PasswordConfirmViewCellNameSpace.height,
                   alignment: .center)
    }
    
    struct PasswordConfirmViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = PasswordConfirmViewCell()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
