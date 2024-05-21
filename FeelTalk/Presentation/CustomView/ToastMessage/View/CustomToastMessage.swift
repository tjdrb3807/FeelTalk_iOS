//
//  CustomToastMessage.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomToastMessage: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: CustomToastMessageNameSpace.messageLabelTextSize)
        
        return label
    }()
    
    init(message: String) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width - (CustomToastMessageNameSpace.leadingInset + CustomToastMessageNameSpace.trailingInset),
                                              height: CustomToastMessageNameSpace.height)))
        backgroundColor = .black.withAlphaComponent(CustomToastMessageNameSpace.backgroundColorAlpha)
        
        layer.cornerRadius = CustomToastMessageNameSpace.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: CustomToastMessageNameSpace.cornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(CustomToastMessageNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = CustomToastMessageNameSpace.shadowOpacity
        layer.shadowRadius = CustomToastMessageNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: CustomToastMessageNameSpace.shadowOffsetWidth,
                                    height: CustomToastMessageNameSpace.shadowOffsetHeight)
        
        self.messageLabel.text = message
        
        self.bind()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind () {
        self.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { v, _ in
                v.hidden()
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() { addSubview(messageLabel) }
    
    private func setConstratins() {
        messageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
}

extension CustomToastMessage {
    func setConstraints() {
        self.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(CustomToastMessageNameSpace.bottomInset)
            $0.leading.equalToSuperview().inset(CustomToastMessageNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CustomToastMessageNameSpace.trailingInset)
            $0.height.equalTo(CustomToastMessageNameSpace.height)
        }
    }
    
    func show(completion: @escaping () -> Void = {}) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [weak self] in
                guard let self = self else { return }
                
                self.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(CustomToastMessageNameSpace.updateBottomInset)
                }
                self.superview?.layoutIfNeeded()
            },completion: { (isCompleted) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { [weak self] in
                    guard let self = self else { return }
                    
                    self.hidden()
                }
            })
    }
    
    func hidden(completion: @escaping () -> Void = {}) {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.snp.updateConstraints { $0.bottom.equalToSuperview().inset(CustomToastMessageNameSpace.bottomInset) }
                self.superview?.layoutIfNeeded()
            },
            completion: { (isCompleted) in
                self.removeFromSuperview()
            })
    }
}

#if DEBUG

import SwiftUI

struct CustomToastMessage_Previews: PreviewProvider {
    static var previews: some View {
        CustomToastMessage_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CustomToastMessageNameSpace.leadingInset + CustomToastMessageNameSpace.trailingInset),
                   height: CustomToastMessageNameSpace.height,
                   alignment: .bottom)
    }
    
    struct CustomToastMessage_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomToastMessage(message: "Alert Messages")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
