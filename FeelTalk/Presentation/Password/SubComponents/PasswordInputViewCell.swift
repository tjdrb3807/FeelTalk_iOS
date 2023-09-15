//
//  PasswordInputViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit

final class PasswordInputViewCell: UIView {
    private lazy var dot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        view.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 1.47) / 2
        view.isHidden = true
        
        return view
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigurations()
        addSubComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() { backgroundColor = .clear }
    
    private func addSubComponents() {
        [dot, bottomBar].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        dot.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalTo(dot.snp.top).offset(12)
        }
        
        bottomBar.snp.makeConstraints {
            $0.top.equalTo(bottomBar.snp.bottom).offset(-2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct PasswordInputViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PasswordInputViewCell_Presentable()
    }
    
    struct PasswordInputViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PasswordInputViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
