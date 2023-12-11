//
//  CustomProgressBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import UIKit
import SnapKit

final class CustomProgressBar: UIView {
    private var persentage: CGFloat
    
    lazy var gaugeBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CustomProgressBarNameSpace.gaugeBarBackgroundColor)
        
        return view
    }()
    
    init(persentage: CGFloat) {
        self.persentage = persentage
        super.init(frame: .zero)
        
        self.setAttribute()
        self.addSubCompnents()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: CustomProgressBarNameSpace.progressBarBackgroundColor)
        isUserInteractionEnabled = false
    }
    
    private func addSubCompnents() {
        addSubview(gaugeBar)
    }
    
    private func setConfiguration() {
        gaugeBar.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * persentage)
        }
    }
}
