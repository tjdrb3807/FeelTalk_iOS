//
//  ChallengeViewNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/14.
//

import UIKit
import SnapKit

final class ChallengeViewNavigationBar: UIView {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_gray_feeltalk")
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var coupleProfileImageButton = ChallengeViewProfileImageButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() { backgroundColor = .clear }
    
    private func setConfig() {
        [logoImageView, coupleProfileImageButton].forEach { addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.44)
            $0.centerY.equalToSuperview()
        }
        
        coupleProfileImageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.44)
            $0.centerY.equalTo(logoImageView.snp.centerY)
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 18.66)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 5.91)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewNavigationBar_Presentable()
    }
    
    struct ChallengeViewNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeViewNavigationBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
