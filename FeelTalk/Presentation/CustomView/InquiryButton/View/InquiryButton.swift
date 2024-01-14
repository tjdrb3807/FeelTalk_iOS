//
//  InquiryButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/01.
//

import UIKit
import SnapKit

final class InquiryButton: UIButton {
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray600)
        
        return view
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
        setTitle(InquiryButtonNameSpace.titleText, for: .normal)
        setTitleColor(UIColor(named: CommonColorNameSpace.gray600), for: .normal)
        titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                  size: InquiryButtonNameSpace.titleTextSize)
    }
    
    private func addSubComponents() { addSubview(bottomBorder) }
    
    private func setConstraints() {
        bottomBorder.snp.makeConstraints {
            $0.top.equalTo(titleLabel!.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(InquiryButtonNameSpace.borderWidth)
        }
    }
}

#if DEBUG

import SwiftUI

struct InquiryButton_Previews: PreviewProvider {
    static var previews: some View {
        InquiryButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: InquiryButtonNameSpace.width,
                   height: InquiryButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct InquiryButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InquiryButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
