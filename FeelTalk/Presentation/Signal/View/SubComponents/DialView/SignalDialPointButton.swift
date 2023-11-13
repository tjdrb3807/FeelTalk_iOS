//
//  SignalDialPointButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalDialPointButton: UIButton {
    var type: SignalType
    
    private lazy var point: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: SignalDialPointButtonNameSpace.width,
                                                     height: SignalDialPointButtonNameSpace.height)))
        imageView.image = UIImage(named: "image_signal_point_default")
        imageView.layer.borderWidth = SignalDialPointButtonNameSpace.pointBorderWidth
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = SignalDialPointButtonNameSpace.pointCornerRadius
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    init(type: SignalType) {
        self.type = type
        super.init(frame: .zero)
        
        self.setProperties()
        self.addSubComponents()
        self.setContsraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() { addSubview(point) }
    
    private func setContsraints() {
        point.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SignalDialPointButtonNameSpace.pointWidth)
            $0.height.equalTo(SignalDialPointButtonNameSpace.pointHeight)
        }
    }
}

extension SignalDialPointButton {
    func isSelected(_ state: Bool) {
        if state {
            switch type {
            case .sexy:
                point.rx.image.onNext(UIImage(named: "image_signal_point_sexy"))
            case .love:
                point.rx.image.onNext(UIImage(named: "image_signal_point_love"))
            case .ambiguous:
                point.rx.image.onNext(UIImage(named: "image_signal_point_ambiguous"))
            case .refuse:
                point.rx.image.onNext(UIImage(named: "image_signal_point_refuse"))
            case .tired:
                point.rx.image.onNext(UIImage(named: "image_signal_point_tired"))
            }
        } else {
            point.rx.image.onNext(UIImage(named: "image_signal_point_default"))
        }
    }
}

#if DEBUG

import SwiftUI

struct SignalDialPointButton_Preview: PreviewProvider {
    static var previews: some View {
        SignalDialPointButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: SignalDialPointButtonNameSpace.width,
                   height: SignalDialPointButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct SignalDialPointButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignalDialPointButton(type: .sexy)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
