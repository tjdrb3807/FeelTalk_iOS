//
//  PasswordInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit

final class PasswordInputView: UIStackView {
    private lazy var firstCell: PasswordInputViewCell = { PasswordInputViewCell() }()
    private lazy var secondCell: PasswordInputViewCell = { PasswordInputViewCell() }()
    private lazy var thirdCell: PasswordInputViewCell = { PasswordInputViewCell() }()
    private lazy var fourthCell: PasswordInputViewCell = { PasswordInputViewCell() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 28
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    private func addSubComponents() {
        [firstCell, secondCell, thirdCell, fourthCell].forEach { addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        
    }
}

#if DEBUG

import SwiftUI

struct PasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordInputView_Presentable()
    }
    
    struct PasswordInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PasswordInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
