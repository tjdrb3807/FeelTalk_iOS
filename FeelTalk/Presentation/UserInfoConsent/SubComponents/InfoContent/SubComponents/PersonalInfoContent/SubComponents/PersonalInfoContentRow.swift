//
//  PersonalInfoContentRow.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit

final class PersonalInfoContentRow: UIView {
    private var title: String
    
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 2.13
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_single_check_unselected"), for: .normal)
        //TODO: selected 아이콘 디자이너에게 요구
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textColor = UIColor(named: "gray_600")
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [checkButton, titleLabel].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        addSubview(totalHorizontalStackView)
        
        titleLabel.snp.makeConstraints { $0.top.trailing.bottom.equalToSuperview() }
        
        totalHorizontalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct PersonalInfoContentRow_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoContentRow_Presentable()
    }
    
    struct PersonalInfoContentRow_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PersonalInfoContentRow(title: "연결된 소셜 계정 정보가 삭제돼요")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
