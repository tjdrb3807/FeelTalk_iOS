//
//  BottomBorderButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit
import SnapKit

final class BottomBorderButton: UIButton {
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray600)
        
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        setTitleColor(UIColor(named: CommonColorNameSpace.gray600), for: .normal)
        titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                  size: BottomBorderButtonNameSpace.titleTextSize)
    }
    
    private func addSubComponents() { addSubview(bottomBorder) }
    
    private func setConstraints() {
        bottomBorder.snp.makeConstraints {
            $0.top.equalTo(titleLabel!.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(BottomBorderButtonNameSpace.borderWidth)
        }
    }
}

#if DEBUG

import SwiftUI

struct BottomBorderButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomBorderButton_Presentable()
    }
    
    struct BottomBorderButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            BottomBorderButton(title: "로그아웃")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
