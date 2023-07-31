//
//  ChallengeViewProfileImageButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/17.
//

import UIKit
import SnapKit

final class ChallengeViewProfileImageButton: UIButton {
    private lazy var partnerImageView = ProfileImageView(superViewType: .challenge)
    private lazy var myImageView = ProfileImageView(superViewType: .challenge)
    
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
        [partnerImageView, myImageView].forEach { addSubview($0) }
        
        partnerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.86)
        }
        
        myImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.86)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewProfileImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewProfileImageButton_Presentable()
    }
    
    struct ChallengeViewProfileImageButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeViewProfileImageButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
