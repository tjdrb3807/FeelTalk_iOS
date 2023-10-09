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
    
    private lazy var spacing: UIView = { UIView() }()
    
    private lazy var myNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: MyPageProfileViewNameSpace.myNicknameLabelTextSize)
        label.sizeToFit()
        label.setLineHeight(height: MyPageProfileViewNameSpace.myNicknameLabelLineHeight)
        
        return label
    }()
    
    private lazy var snsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    lazy var partnerInfoButton: MyPagePartnerInfoButton = { MyPagePartnerInfoButton() }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width - (MyPageProfileViewNameSpace.leadingInset + MyPageProfileViewNameSpace.trailingInset),
                                              height: MyPageProfileViewNameSpace.height)))
        
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
                v.setUpMyNicknameLabel(with: info)
                v.setUpSNSImageView(with: info)
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
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: MyPageProfileViewNameSpace.cornerRadius).cgPath
        layer.shadowColor = UIColor(red: MyPageProfileViewNameSpace.shadowRedColor,
                                    green: MyPageProfileViewNameSpace.shadowGreenColor,
                                    blue: MyPageProfileViewNameSpace.shadowBlueColor,
                                    alpha: MyPageProfileViewNameSpace.shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: MyPageProfileViewNameSpace.shadowOffsetWidth,
                                    height: MyPageProfileViewNameSpace.shadowOffsetHeight)
        layer.shadowOpacity = MyPageProfileViewNameSpace.shadowOpacity
        layer.shadowRadius = MyPageProfileViewNameSpace.shadowRadius
    }
    
    private func addSubComponents() {
        addViewSubComponent()
        addTotalStackViewSubComponents()
        addMyNicknameStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeMyNicknameStackViewConstraints()
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
        [myNicknameStackView, partnerInfoButton].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeMyNicknameStackViewConstraints() {
        myNicknameStackView.snp.makeConstraints { $0.height.equalTo(MyPageProfileViewNameSpace.myNicknameStackViewHeight) }
    }
    
    private func addMyNicknameStackViewSubComponents() {
        [spacing, myNicknameLabel, snsImageView].forEach { myNicknameStackView.addArrangedSubview($0) }
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
    private func setUpMyNicknameLabel(with myInfo: MyInfo) {
        myNicknameLabel.rx.text.onNext(myInfo.nickname)
        myNicknameLabel.snp.updateConstraints { $0.width.equalTo(myNicknameLabel.intrinsicContentSize) }
    }
    
    private func setUpSNSImageView(with myInfo: MyInfo) {
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
            let view = MyPageProfileView()
            view.userInfo.accept(.init(nickname: "성규", snsType: .naver))
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
