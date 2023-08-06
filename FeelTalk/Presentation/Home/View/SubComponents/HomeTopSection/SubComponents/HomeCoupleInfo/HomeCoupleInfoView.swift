//
//  HomeCoupleInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

final class HomeCoupleInfoView: UIView {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 2.13
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // SubComponents
    private lazy var coupleProfileImageView = HomeCoupleProfileImageView()
    private lazy var messageView = HomeMessageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "main_500")
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [coupleProfileImageView, messageView].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        coupleProfileImageView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 17.06)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.92)
        }
        
        messageView.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.55) }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 18.4)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeCoupleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCoupleInfoView_Presentable()
    }
    
    struct HomeCoupleInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeCoupleInfoView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
#endif
