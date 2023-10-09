//
//  MyPageProfileButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit

// MARK: 간소화 버전에서는 위 버튼을 사용하지 않는다.
final class MyPageProfileButton: UIButton {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: CommonColorNameSpace.gray300)
        imageView.layer.borderColor = UIColor(named: CommonColorNameSpace.gray100)?.cgColor
        imageView.layer.borderWidth = MyPageProfileButtonNameSpace.profileImageViewBorderWidth
        imageView.layer.cornerRadius = MyPageProfileButtonNameSpace.profileImageViewCornerRadius
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var modifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MyPageProfileButtonNameSpace.modifyImageViewImage)
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = MyPageProfileButtonNameSpace.modifyImageViewCornerRadius
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() { backgroundColor = .clear }
    
    private func addSubComponents() { addButtonSubComponents() }
    
    private func setConstraints() {
        makeProfileImageViewConstraints()
        makeModifyImageViewConstraints()
    }
}

extension MyPageProfileButton {
    private func addButtonSubComponents() { [profileImageView, modifyImageView].forEach { addSubview($0) } }
    
    private func makeProfileImageViewConstraints() {
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(MyPageProfileButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(MyPageProfileButtonNameSpace.profileImageViewHeight)
        }
    }
    
    private func makeModifyImageViewConstraints() {
        modifyImageView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
            $0.width.equalTo(MyPageProfileButtonNameSpace.modifyImageViewWidth)
            $0.height.equalTo(MyPageProfileButtonNameSpace.modifyImageViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct MyPageProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        MyPageProfileButton_Presentable()
    }
    
    struct MyPageProfileButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyPageProfileButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) { }
    }
}

#endif
