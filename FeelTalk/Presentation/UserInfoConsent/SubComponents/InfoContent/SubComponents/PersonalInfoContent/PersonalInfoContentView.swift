//
//  PersonalInfoContentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/08.
//

import UIKit
import UIKit

final class PersonalInfoContentView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentRowVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.49
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var firstContentRow = PersonalInfoContentRow(title: "연결된 소셜 계정 정보가 삭제돼요 01")
    lazy var secondContentRow = PersonalInfoContentRow(title: "연결된 소셜 계정 정보가 삭제돼요 02")
    lazy var thirdContentRow = PersonalInfoContentRow(title: "연결된 소셜 계정 정보가 삭제돼요 03")
    lazy var fourthContentRow = PersonalInfoContentRow(title: "연결된 소셜 계정 정보가 삭제돼요 04")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [firstContentRow, secondContentRow, thirdContentRow, fourthContentRow].forEach {
            contentRowVerticalStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
        }
        
        [spacer, contentRowVerticalStackView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        spacer.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 1.47) }
        
        contentRowVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct PersonalInfoContentView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoContentView_Presentable()
    }
    
    struct PersonalInfoContentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PersonalInfoContentView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
