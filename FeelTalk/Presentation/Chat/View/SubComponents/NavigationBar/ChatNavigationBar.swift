//
//  ChatNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatNavigationBar: UIView {
    let partnerNickname = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    private lazy var partnerNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: ChatNavigationBarNameSpace.partnerNicknameLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChatNavigationBarNameSpace.menuButtonImage),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: ChatNavigationBarNameSpace.height)))
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        partnerNickname
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { v, data in
                v.partnerNicknameLabel.rx.text.onNext(data)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
        
        layer.cornerRadius = ChatNavigationBarNameSpace.cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: ChatNavigationBarNameSpace.shadowCornerRadius).cgPath
        layer.shadowColor = UIColor(red: ChatNavigationBarNameSpace.shadowRedColor,
                                    green: ChatNavigationBarNameSpace.shadowGreenColor,
                                    blue: ChatNavigationBarNameSpace.shadowBlueColor,
                                    alpha: ChatNavigationBarNameSpace.shadowColorAlpha).cgColor
        layer.shadowOpacity = ChatNavigationBarNameSpace.shadowOpacity
        layer.shadowRadius = ChatNavigationBarNameSpace.shadowRadius
        layer.shadowOffset = CGSize(width: ChatNavigationBarNameSpace.shadowOffsetWidth,
                                    height: ChatNavigationBarNameSpace.shadowOffsetHeight)
    }
    
    private func addSubComponents() {
        addNaivgationBarSubComponents()
    }
    
    private func setConstraints() {
        makePartnerNicknameLabelConstraints()
        makeMenuButtonConstraints()
    }
}

extension ChatNavigationBar {
    private func addNaivgationBarSubComponents() {
        [partnerNicknameLabel, menuButton].forEach { addSubview($0) }
    }
    
    private func makePartnerNicknameLabelConstraints() {
        partnerNicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeMenuButtonConstraints() {
        menuButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ChatNavigationBarNameSpace.menuButtonTrailingInset)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatNavigationBar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChatNavigationBarNameSpace.height,
                   alignment: .center)
    }
    
    struct ChatNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChatNavigationBar()
            v.partnerNickname.accept("Partner")
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
