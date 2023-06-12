//
//  QuestionCoupleInfoView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionCoupleInfoView: UIView {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var coupleProfileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var partnerProfileImageView = CommonProfileImageView(superViewType: .question)
    private lazy var myProfileImageView = CommonProfileImageView(superViewType: .question)
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.06.01"
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textColor = UIColor(named: "main_300")
        label.textAlignment = .right
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "main_500")
    }
    
    private func setConfig() {
        [partnerProfileImageView, myProfileImageView].forEach { coupleProfileImageView.addSubview($0) }
        
        partnerProfileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 8.53)
            $0.height.equalTo(partnerProfileImageView.snp.width)
        }
        
        myProfileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.06)
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 8.53)
            $0.height.equalTo(myProfileImageView.snp.width)
        }
        
        [coupleProfileImageView, dateLabel].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        coupleProfileImageView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 13.6)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.94)
        }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionCoupleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCoupleInfoView_Presentable()
    }
    
    struct QuestionCoupleInfoView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionCoupleInfoView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
