//
//  CustomBottomBorderButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import UIKit
import SnapKit

final class CustomBottomBorderButton: UIButton {
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: self.frame.width,
                height: CustomBottomBorderButtonNameSpace.bottomBorderHeight))
        
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor(named: CommonColorNameSpace.gray500), for: .normal)
        titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                  size: CustomBottomBorderButtonNameSpace.textSize)
        backgroundColor = .clear
        
        addSubComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubComponents() {
        addSubview(bottomBorder)
    }
}

#if DEBUG

import SwiftUI

struct CustomBottomBorderButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomBorderButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: CustomBottomBorderButtonNameSpace.testWidth,
                   height: CustomBottomBorderButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct CustomBottomBorderButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomBottomBorderButton(title: "답변이 기억나지 않아요")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
