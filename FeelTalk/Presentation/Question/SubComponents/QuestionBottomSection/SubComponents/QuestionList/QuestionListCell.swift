//
//  QuestionListCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionListCell: UITableViewCell {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.06
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "100."
        label.font = UIFont(name: "pretendard-semi_bold", size: 16.0)
        label.textColor = UIColor(named: "gray_500")
        label.numberOfLines = 1
        label.sizeToFit()
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연인이 가장 예뻐 보이는 순간은? 가장 예뻐 보이는 순간은?"
        label.font = UIFont(name: "pretendard-semi_bold", size: 16.0)
        label.textColor = UIColor(named: "gray_500")
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = .clear
    
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setAttribute()
        self.setConfig()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0.0,
                                                                     left: (UIScreen.main.bounds.width / 100) * 5.33,
                                                                     bottom: (UIScreen.main.bounds.height / 100) * 0.98,
                                                                     right: (UIScreen.main.bounds.width / 100) * 5.33))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        backgroundColor = UIColor(named: "gray_100")
    }
    
    private func setConfig() {
        [indexLabel, titleLabel].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        indexLabel.snp.makeConstraints { $0.width.height.equalTo(indexLabel.intrinsicContentSize) }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(titleLabel.intrinsicContentSize).priority(.medium)
        }
        
        contentView.addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 1.97 )
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 4.26)
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionListCell_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListCell_Presentable()
    }
    
    struct QuestionListCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionListCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
