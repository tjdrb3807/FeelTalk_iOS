//
//  LoginSpeechBubbleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import UIKit
import SnapKit

final class LoginSpeechBubbleView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LoginSpeechBubbleViewNameSpace.titelLabelText
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: LoginSpeechBubbleViewNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .black
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: LoginSpeechBubbleViewNameSpace.tipStartX,
                              y: LoginSpeechBubbleViewNameSpace.tipStartY))
        path.addLine(to: CGPoint(x: LoginSpeechBubbleViewNameSpace.tipSecondX,
                                 y: LoginSpeechBubbleViewNameSpace.tipSecondY))
        path.addLine(to: CGPoint(x: LoginSpeechBubbleViewNameSpace.tipThirdX,
                                 y: LoginSpeechBubbleViewNameSpace.tipThirdY))
        path.addLine(to: CGPoint(x: LoginSpeechBubbleViewNameSpace.tipEndX,
                                 y: LoginSpeechBubbleViewNameSpace.tipEndY))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.black.cgColor
        
        layer.insertSublayer(shape, at: 0)
        layer.masksToBounds = false
    }
    
    private func addSubComponents() { addViewSubComponents() }
    
    private func setConstraints() { makeTitleLabelConstraints() }
}

extension LoginSpeechBubbleView {
    private func addViewSubComponents() { addSubview(titleLabel) }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct LoginSpeechBubbleView_Preview: PreviewProvider {
    static var previews: some View {
        LoginSpeechBubbleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: LoginSpeechBubbleViewNameSpace.width,
                   height: LoginSpeechBubbleViewNameSpace.height,
                   alignment: .center)
    }
    
    struct LoginSpeechBubbleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LoginSpeechBubbleView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
