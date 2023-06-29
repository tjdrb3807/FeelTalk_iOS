//
//  SensitiveInfoContentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/08.
//

import UIKit
import SnapKit

final class SensitiveInfoContentView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = """
        삼성 헬스의 기능을 제공하기 위해, 헬스 데이터를 수집하고 처리합니다. 상세 정보에서 헬스 데이터 수집항목, 수집방법, 동의철회방법을 확인하세요.
        헬스 데이터 처리에 대한 동의는 선택사항입니다.
        """
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textColor = UIColor(named: "gray_600")
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
                
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [spacer, contentLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        spacer.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 1.47) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct SensitiveInfoContentView_Previews: PreviewProvider {
    static var previews: some View {
        SensitiveInfoContentView_Presentable()
    }
    
    struct SensitiveInfoContentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SensitiveInfoContentView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
