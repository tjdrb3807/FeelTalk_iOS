//
//  LockingPasswordInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import UIKit
import SnapKit

final class LockingPasswordInputView: UIStackView {
    private lazy var firstCell: LockingPasswordInputViewCell = { LockingPasswordInputViewCell() }()
    private lazy var secondCell: LockingPasswordInputViewCell = { LockingPasswordInputViewCell() }()
    private lazy var thirdCell: LockingPasswordInputViewCell = { LockingPasswordInputViewCell() }()
    private lazy var fourthCell: LockingPasswordInputViewCell = { LockingPasswordInputViewCell() }()
    
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
        spacing = LockingPasswordInputViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    private func addSubComponents() {
        [firstCell, secondCell, thirdCell, fourthCell].forEach { addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct LockingPasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        LockingPasswordInputView_Presentable()
    }
    
    struct LockingPasswordInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockingPasswordInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
