//
//  InviteCodeBottomSheetView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/22.
//

import UIKit
import SnapKit

final class InviteCodeBottomSheetView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공유받은 연결코드를 입력해주세요"
        label.textColor = .black
        label.font = UIFont(name: "pretendard-medium", size: 20)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "연결코드 입력하기"
        textField.backgroundColor = UIColor(named: "gray_400")
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        
        return textField
    }()
    
    private lazy var connectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("연결하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "main_400")
        button.layer.cornerRadius = 59 / 2
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        [titleLabel, textField, connectionButton].forEach { addSubview($0) }
    }
    
    private func setConfiguration() {
        makeTitleLabelConstraints()
        makeTextFieldConstraints()
        makeConnectionButtonConstraints()
    }
}

extension InviteCodeBottomSheetView {
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
    }
    
    private func makeTextFieldConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18.0)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func makeConnectionButtonConstraints() {
        connectionButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(23)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(59)
        }
    }
}
