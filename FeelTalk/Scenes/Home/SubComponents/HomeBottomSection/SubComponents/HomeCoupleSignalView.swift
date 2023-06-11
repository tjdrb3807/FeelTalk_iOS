//
//  HomeCoupleSignalView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class HomeCoupleSignalView: UIView {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var partnerSignalButton = HomeSignalButton(target: .partner)
    lazy var mySignalButton = HomeSignalButton(target: .me)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "gray_100")
        layer.cornerRadius = 16.0
    }
    
    private func setConfig() {
        [partnerSignalButton, mySignalButton].forEach { subComponent in
            totalHorizontalStackView.addArrangedSubview(subComponent)
            
            subComponent.snp.makeConstraints { $0.width.equalTo((UIScreen.main.bounds.width / 100) * 17.06) }
        }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 3.94)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 8.80)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeCoupleSignalView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCoupleSignalView_Presentable()
    }
    
    struct HomeCoupleSignalView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeCoupleSignalView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
