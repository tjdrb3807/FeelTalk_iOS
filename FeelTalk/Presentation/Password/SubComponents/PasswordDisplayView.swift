//
//  PasswordDisplayView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordDisplayView: UIStackView {
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "암호 입력" // TODO: ViewMode에 따라 변경
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 24.0)
        label.backgroundColor = .clear
        label.setLineHeight(height: 36.0)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하고자 하는 암호를 입력해주세요." // TODO: ViewMode에 따라 변경
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        label.setLineHeight(height: 24.0)
        
        return label
    }()
    
    private lazy var passwordInputView: PasswordInputView = { PasswordInputView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = 60
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makePasswordInputViewConstraints()
    }
}

extension PasswordDisplayView {
    private func addViewSubComponents() {
        [labelStackView, passwordInputView].forEach { addArrangedSubview($0) }
    }
    
    private func makePasswordInputViewConstraints() {
        passwordInputView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(28)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct PasswordDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordDisplayView_Presentable()
    }
    
    struct PasswordDisplayView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PasswordDisplayView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
