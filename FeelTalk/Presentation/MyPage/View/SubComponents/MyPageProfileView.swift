//
//  MyPageProfileView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageProfileView: UIView {
    let userInfo = PublishRelay<MyInfo>()
    let partnerInfo = PublishRelay<PartnerInfo>()
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponents
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPageProfileViewNameSpace.totalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var myProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPageProfileViewNameSpace.myProfileStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var myProfileButton: MyPageProfileButton = { MyPageProfileButton() }()
    
    private lazy var myNicknameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPageProfileViewNameSpace.myNicknameStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var myNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: MyPageProfileViewNameSpace.myNicknameLabelTextSize)
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var snsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MyPageProfileViewNameSpace.kakaoImage)
        
        return imageView
    }()
    
    lazy var partnerInfoButton: MyPagePartnerInfoButton = { MyPagePartnerInfoButton() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        userInfo
            .withUnretained(self)
            .bind { v, info in
                v.updateMyNicknameLabel(with: info)
                v.updateSNSImageView(with: info)
            }.disposed(by: disposeBag)
        
        partnerInfo
            .bind(to: partnerInfoButton.partnerInfo)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .white
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray200)?.cgColor
        layer.borderWidth = MyPageProfileViewNameSpace.borderWidth
        layer.cornerRadius = MyPageProfileViewNameSpace.cornerRadius
    }
    
    private func addSubComponents() {
        addViewSubComponent()
        addTotalStackViewSubComponents()
        addMyProfileStackViewSubComponents()
        addMyNicknameStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeProfileStackViewConstraints()
        makeMyProfileButtonConstraints()
        makeMyNicknameLabelConstraints()
        makePartnerInfoButtonConstraints()
    }
}

// MARK: Default consfiguration settings method.
extension MyPageProfileView {
    private func addViewSubComponent() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(MyPageProfileViewNameSpace.totalStackViewTopInset)
            $0.leading.equalToSuperview().inset(MyPageProfileViewNameSpace.totalStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(MyPageProfileViewNameSpace.totalStackViewTrailingInset)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [myProfileStackView, partnerInfoButton].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeProfileStackViewConstraints() {
        myProfileStackView.snp.makeConstraints { $0.height.equalTo(MyPageProfileButtonNameSpace.profileImageViewWidth) }
    }
    
    private func addMyProfileStackViewSubComponents() {
        [myProfileButton, myNicknameStackView].forEach { myProfileStackView.addArrangedSubview($0) }
    }
    
    private func makeMyProfileButtonConstraints() {
        myProfileButton.snp.makeConstraints {
            $0.width.equalTo(MyPageProfileButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(MyPageProfileButtonNameSpace.profileImageViewHeight)
        }
    }
    
    private func addMyNicknameStackViewSubComponents() {
        [myNicknameLabel, snsImageView].forEach { myNicknameStackView.addArrangedSubview($0) }
    }
    
    private func makeMyNicknameLabelConstraints() {
        myNicknameLabel.snp.makeConstraints { $0.width.equalTo(myNicknameLabel.intrinsicContentSize) }
    }
    
    private func makePartnerInfoButtonConstraints() {
        partnerInfoButton.snp.makeConstraints { $0.height.equalTo(MyPagePartnerInfoButtonNameSpace.height) }
    }
}

// MARK: Update configuration settings method.
extension MyPageProfileView {
    private func updateMyNicknameLabel(with myInfo: MyInfo) {
        myNicknameLabel.rx.text.onNext(myInfo.nickname)
        myNicknameLabel.snp.updateConstraints { $0.width.equalTo(myNicknameLabel.intrinsicContentSize) }
    }
    
    private func updateSNSImageView(with myInfo: MyInfo) {
        switch myInfo.snsType {
        case .appleIOS:
            snsImageView.rx.image.onNext(UIImage(named: MyPageProfileViewNameSpace.appleLogoImage))
        case .google:
            snsImageView.rx.image.onNext(UIImage(named: MyPageProfileViewNameSpace.googleImage))
        case .kakao:
            snsImageView.rx.image.onNext(UIImage(named: MyPageProfileViewNameSpace.kakaoImage))
        case .naver:
            snsImageView.rx.image.onNext(UIImage(named: MyPageProfileViewNameSpace.naverImage))
        }
    }
}

#if DEBUG

import SwiftUI

struct MyPageProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageProfileView_Presentable()
    }
    
    struct MyPageProfileView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyPageProfileView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
