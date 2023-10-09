//
//  LockingPasswordInputViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import UIKit
import SnapKit

final class LockingPasswordInputViewCell: UIView {
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        view.layer.cornerRadius = LockingPasswordInputViewCellNameSpace.circleViewCornerRadius
        
        return view
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() { backgroundColor = .clear }
    
    private func addSubComponents() { [circleView, barView].forEach { addSubview($0) } }
    
    private func setConstraints() {
        circleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(LockingPasswordInputViewCellNameSpace.circleViewHorizontalInset)
            $0.bottom.equalTo(circleView.snp.top).offset(LockingPasswordInputViewCellNameSpace.circleViewHeight)
        }
        
        barView.snp.makeConstraints {
            $0.top.equalTo(barView.snp.bottom).offset(LockingPasswordInputViewCellNameSpace.barViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingPasswordInputViewCell_Previews: PreviewProvider {
    static var previews: some View {
        LockingPasswordInputViewCell_Presentable()
    }
    
    struct LockingPasswordInputViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockingPasswordInputViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
