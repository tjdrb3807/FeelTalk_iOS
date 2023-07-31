//
//  HomeCoupleProfileImageView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

final class HomeCoupleProfileImageView: UIView {
    private lazy var partnerProfileImage = ProfileImageView(superViewType: .home)
    private lazy var myProfileImage = ProfileImageView(superViewType: .home)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConfig() {
        [partnerProfileImage, myProfileImage].forEach { addSubview($0) }
        
        partnerProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 10.66)
            $0.height.equalTo(partnerProfileImage.snp.width)
        }
        
        myProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(partnerProfileImage.snp.leading).offset((UIScreen.main.bounds.width / 100) * 6.40)
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 10.66)
            $0.height.equalTo(myProfileImage.snp.width)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeCoupleProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCoupleProfileImageView_Presentable()
            
    }
    
    struct HomeCoupleProfileImageView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeCoupleProfileImageView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
