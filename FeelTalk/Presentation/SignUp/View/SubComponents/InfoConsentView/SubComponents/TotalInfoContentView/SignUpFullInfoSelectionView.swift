//
//  SignUpFullInfoSelectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpFullInfoSelectionView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = SignUpFullInfoSelectionViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var fullSelectionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SignUpFullInfoSelectionViewNameSpace.fullSelectionButtonImage),
                        for: .normal)
        button.setImage(UIImage(named: "icon_circle_check_able"),
                        for: .selected)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = SignUpFullInfoSelectionViewNameSpace.contentLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: SignUpFullInfoSelectionViewNameSpace.contentLabelTextSize)
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    lazy var presentDetailViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SignUpFullInfoSelectionViewNameSpace.presentDetailViewButtonImage),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = SignUpFullInfoSelectionViewNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makePresentDetailViewButtonConstraints()
    }
}

extension SignUpFullInfoSelectionView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignUpFullInfoSelectionViewNameSpace.contentStackViewTopInset)
            $0.leading.equalToSuperview().inset(SignUpFullInfoSelectionViewNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(SignUpFullInfoSelectionViewNameSpace.contentStakcViewTrailingInset)
            $0.bottom.equalToSuperview().inset(SignUpFullInfoSelectionViewNameSpace.contentStackViewBottomInset)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [fullSelectionButton, contentLabel, presentDetailViewButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makePresentDetailViewButtonConstraints() {
        presentDetailViewButton.snp.makeConstraints { $0.width.equalTo(SignUpFullInfoSelectionViewNameSpace.presentDetailViewButtonWidth) }
    }
}

#if DEBUG

import SwiftUI

struct SignUpFullInfoSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpFullInfoSelectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: SignUpFullInfoSelectionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct SignUpFullInfoSelectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignUpFullInfoSelectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
