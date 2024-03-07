//
//  PasswordConfirmView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordConfirmView: UIStackView {
    let passwordCountObserver = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private lazy var firstConfirmCell: PasswordConfirmViewCell = { PasswordConfirmViewCell() }()
    
    private lazy var secondConfirmCell: PasswordConfirmViewCell = { PasswordConfirmViewCell() }()
    
    private lazy var thirdConfirmCell: PasswordConfirmViewCell = { PasswordConfirmViewCell() }()
    
    private lazy var fourthConfirmCell: PasswordConfirmViewCell = { PasswordConfirmViewCell() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind () {
        passwordCountObserver
            .withUnretained(self)
            .bind { v, count in
                guard let cellArr = v.subviews as? [PasswordConfirmViewCell] else { return }
                switch count {
                case 0:
                    cellArr.forEach { cell in cell.isInputed.accept(false) }
                case 1:
                    cellArr[0].isInputed.accept(true)
                    cellArr[1].isInputed.accept(false)
                    cellArr[2].isInputed.accept(false)
                    cellArr[3].isInputed.accept(false)
                case 2:
                    cellArr[0].isInputed.accept(true)
                    cellArr[1].isInputed.accept(true)
                    cellArr[2].isInputed.accept(false)
                    cellArr[3].isInputed.accept(false)
                case 3:
                    cellArr[0].isInputed.accept(true)
                    cellArr[1].isInputed.accept(true)
                    cellArr[2].isInputed.accept(true)
                    cellArr[3].isInputed.accept(false)
                case 4:
                    cellArr.forEach { cell in cell.isInputed.accept(true) }
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = PasswordConfirmViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
}

extension PasswordConfirmView {
    private func addViewSubComponents() {
        [firstConfirmCell, secondConfirmCell, thirdConfirmCell, fourthConfirmCell].forEach { addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct PasswordConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordConfirmView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: PasswordConfirmViewNameSpace.width,
                   height: PasswordConfirmViewNameSpace.height,
                   alignment: .center)
    }
    
    struct PasswordConfirmView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = PasswordConfirmView()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
