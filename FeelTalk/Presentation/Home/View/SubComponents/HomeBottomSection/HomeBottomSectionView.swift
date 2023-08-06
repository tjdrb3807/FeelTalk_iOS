//
//  HomeBottomSectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class HomeBottomSectionView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.47
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 시그널"
        label.font = UIFont(name: "pretendard-medium", size: 20.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var coupleSignalView = HomeCoupleSignalView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [headerLabel, coupleSignalView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        headerLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.69) }
        
        coupleSignalView.snp.makeConstraints { $0.width.equalToSuperview() }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeBottomSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBottomSectionView_Presentable()
    }
    
    struct HomeBottomSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeBottomSectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
