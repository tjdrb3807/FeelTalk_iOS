//
//  HomeMessageView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

final class HomeMessageView: UIView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘도 서로에 대해 더 알아가봐요!"
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 8.0
        label.backgroundColor = UIColor(named: "main_100")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "main_500")
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0.0, y: 27))
        path.addLine(to: CGPoint(x: (UIScreen.main.bounds.width / 100) * 2.4, y: 27))
        path.addLine(to: CGPoint(x: (UIScreen.main.bounds.width / 100) * 2.4, y: 13))
        path.addLine(to: CGPoint(x: 0.0, y: 27))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor(named: "main_100")?.cgColor
        
        layer.insertSublayer(shape, at: 0)
        layer.masksToBounds = false
    }
    
    private func setConfig() {
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo((UIScreen.main.bounds.width / 100) * 2.4)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeMessageView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMessageView_Presentable()
    }
    
    struct HomeMessageView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeMessageView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

