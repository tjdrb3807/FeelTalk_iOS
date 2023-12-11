//
//  ChatDateCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import UIKit
import SnapKit

final class ChatDateCell: UICollectionViewCell {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "YYYY년 MM월 DD일"
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        
        return label
    }()
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .red.withAlphaComponent(0.2)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeLineConstratins()
        makeDateLabelConstraints()
    }
}

extension ChatDateCell {
    private func addViewSubComponents() { contentView.addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func addContentStackViewSubComponents() {
        [leftLine, dateLabel, rightLine].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDateLabelConstraints() {
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(dateLabel.intrinsicContentSize.width)
        }
    }
    
    private func makeLineConstratins() {
        [leftLine, rightLine].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(1)
            }
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatDateCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatDateCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 42,
                   alignment: .center)
    }
    
    struct ChatDateCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatDateCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
