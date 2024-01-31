//
//  MyPagePartnerInfoButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
 
final class MyPagePartnerInfoButton: UIButton {
    let partnerInfo = PublishRelay<PartnerInfo>()
    private let disposeBag = DisposeBag()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPagePartnerInfoButtonNameSpace.horizontalStakcViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPagePartnerInfoButtonNameSpace.verticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = MyPagePartnerInfoButtonNameSpace.descriptionStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = MyPagePartnerInfoButtonNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: MyPagePartnerInfoButtonNameSpace.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var descriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MyPagePartnerInfoButtonNameSpace.descriptionImageViewImage)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var partnerNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: MyPagePartnerInfoButtonNameSpace.partnerNicknameLabelTextSize)
        label.asFont(targetString: "UserName",
                     font: UIFont(name: CommonFontNameSpace.pretendardMedium,
                                  size: MyPagePartnerInfoButtonNameSpace.partnerNicknameLabelTextSize)!)
        label.backgroundColor = .clear
        
        return label
    }()

    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MyPagePartnerInfoButtonNameSpace.rightArrowImageViewImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        partnerInfo
            .withUnretained(self)
            .bind { v, info in
                v.updatePartnerNicknameLabel(with: info)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main100)
        layer.borderColor = UIColor(named: CommonColorNameSpace.main300)?.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = MyPagePartnerInfoButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addButtonSubComponents()
        addHorizontalStackViewSubComponents()
        addVerticalStackViewSubComponent()
        addDescriptionStackViewSubComponents()
    }
    
    private func setConstratins() {
        makeHorizontalStackViewConstraints()
        makeDescriptionLableConstraints()
        makeRightArrowImageViewConstratins()
        makeDescriptionLableConstraints()
        makeDescriptionImageViewConstraints()
    }
}

extension MyPagePartnerInfoButton {
    private func addButtonSubComponents() { addSubview(horizontalStackView) }
    
    private func makeHorizontalStackViewConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(MyPagePartnerInfoButtonNameSpace.horizontalStackViewLeadingInset)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addHorizontalStackViewSubComponents() {
        [verticalStackView, rightArrowImageView].forEach { horizontalStackView.addArrangedSubview($0) }
    }
    
    private func makeRightArrowImageViewConstratins() {
        rightArrowImageView.snp.makeConstraints { $0.width.equalTo(CommonConstraintNameSpace.buttonWidth) }
    }
    private func addVerticalStackViewSubComponent() {
        [descriptionStackView, partnerNicknameLabel].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionStackViewConstraints() {
        descriptionStackView.snp.makeConstraints { $0.height.equalTo(MyPagePartnerInfoButtonNameSpace.descriptionStackViewHeight) }
    }
    
    private func addDescriptionStackViewSubComponents() {
        [descriptionLabel, descriptionImageView].forEach { descriptionStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLableConstraints() {
        descriptionLabel.snp.makeConstraints { $0.width.equalTo(descriptionLabel.intrinsicContentSize) }
    }
    
    private func makeDescriptionImageViewConstraints() {
        descriptionImageView.snp.makeConstraints {
            $0.height.equalTo(MyPagePartnerInfoButtonNameSpace.descriptionImageViewWidth)
            $0.width.equalTo(MyPagePartnerInfoButtonNameSpace.descriptionImageViewHeight)
        }
    }
}

extension MyPagePartnerInfoButton {
    private func updatePartnerNicknameLabel(with userInfo: PartnerInfo) {
        partnerNicknameLabel.rx.text.onNext("\(userInfo.nickname)님과 함께하고 있어요")
        partnerNicknameLabel.asFont(targetString: "\(userInfo.nickname)",
                                    font: UIFont(name: CommonFontNameSpace.pretendardMedium,
                                                 size: MyPagePartnerInfoButtonNameSpace.partnerNicknameLabelTextSize)!)
    }
}

#if DEBUG

import SwiftUI

struct MyPagePartnerInfoButton_Previews: PreviewProvider {
    static var previews: some View {
        MyPagePartnerInfoButton_Presentable()
    }
    
    struct MyPagePartnerInfoButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = MyPagePartnerInfoButton()
            view.partnerInfo.accept(PartnerInfo(nickname: "partner",
                                                snsType: .google))
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

