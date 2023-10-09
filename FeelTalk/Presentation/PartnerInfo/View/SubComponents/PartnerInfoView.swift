//
//  PartnerInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PartnerInfoView: UIView {
    let model = PublishRelay<PartnerInfo>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = PartnerInfoViewNameSpcae.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerInfoViewNameSpcae.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: PartnerInfoViewNameSpcae.descriptionLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var nicknameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = PartnerInfoViewNameSpcae.nicknameStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var spacingViwe: UIView = { UIView() }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: PartnerInfoViewNameSpcae.nicknameLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var snsImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width - (PartnerInfoViewNameSpcae.leadingInset + PartnerInfoViewNameSpcae.trailingInset),
                                              height: PartnerInfoViewNameSpcae.height)))
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.nicknameLabel.rx.text.onNext(model.nickname)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .white
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray200)?.cgColor
        layer.borderWidth = PartnerInfoViewNameSpcae.borderWidth
        layer.cornerRadius = PartnerInfoViewNameSpcae.cornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: PartnerInfoViewNameSpcae.cornerRadius).cgPath
        layer.shadowColor = UIColor(red: PartnerInfoViewNameSpcae.shadowRedColor,
                                    green: PartnerInfoViewNameSpcae.shadowGreenColor,
                                    blue: PartnerInfoViewNameSpcae.shadowBlueColor,
                                    alpha: PartnerInfoViewNameSpcae.shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: PartnerInfoViewNameSpcae.shadowOffsetWidth,
                                    height: PartnerInfoViewNameSpcae.shadowOffsetHeight)
        layer.shadowOpacity = PartnerInfoViewNameSpcae.shadowOpacity
        layer.shadowRadius = PartnerInfoViewNameSpcae.shadowRadius
    }
    
    private func addSubComponents() {
        addViewSubComponent()
        addContentStackViewSubComponents()
        addNicknameStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeDescriptionLabelConstraints()
        makeNicknameStackViewConstraints()
    }
}

extension PartnerInfoView {
    private func addViewSubComponent() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(PartnerInfoViewNameSpcae.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(PartnerInfoViewNameSpcae.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(PartnerInfoViewNameSpcae.contentStackViewTrailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [descriptionLabel, nicknameStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(PartnerInfoViewNameSpcae.descriptionLabelHeight) }
    }
    
    private func makeNicknameStackViewConstraints() {
        nicknameStackView.snp.makeConstraints { $0.height.equalTo(PartnerInfoViewNameSpcae.nicknameLabelHeight) }
    }
    
    private func addNicknameStackViewSubComponents() {
        [spacingViwe, nicknameLabel, snsImageView].forEach { nicknameStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct PartnerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerInfoView_Presentable()
            .frame(width: UIScreen.main.bounds.width - (PartnerInfoViewNameSpcae.leadingInset + PartnerInfoViewNameSpcae.trailingInset),
                   height: PartnerInfoViewNameSpcae.height,
                   alignment: .center)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct PartnerInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = PartnerInfoView()
            view.model.accept(.init(nickname: "Partner"))
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
