//
//  ChatDataBoundaryCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import UIKit
import SnapKit

final class ChatDateBoundaryCell: UICollectionViewCell {
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
                            size: ChatDateBoundaryCellNameSpace.dateLabelTextSize)
        
        return label
    }()
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: ChatDateBoundaryCellNameSpace.contentViewTopInset,
                                                                     left: ChatDateBoundaryCellNameSpace.contentViewLeftInset,
                                                                     bottom: ChatDateBoundaryCellNameSpace.contentViewBottomInset,
                                                                     right: ChatDateBoundaryCellNameSpace.contentViewRightInset))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeLeftLineConstraints()
        makeDateLabelConstraints()
        makeRightLineConstraints()
    }
}

extension ChatDateBoundaryCell {
    private func addViewSubComponents() {
        [leftLine, dateLabel, rightLine].forEach { contentView.addSubview($0) }
    }
    
    private func makeLeftLineConstraints() {
        leftLine.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ChatDateBoundaryCellNameSpace.leftLineLeadingInset)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(ChatDateBoundaryCellNameSpace.leftLineTrailingOffset)
            $0.height.equalTo(ChatDateBoundaryCellNameSpace.leftLineHeight)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func makeDateLabelConstraints() {
        dateLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func makeRightLineConstraints() {
        rightLine.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(ChatDateBoundaryCellNameSpace.rightLineLeadingOffset)
            $0.trailing.equalToSuperview().inset(ChatDateBoundaryCellNameSpace.rightLineTrailingInset)
            $0.height.equalTo(ChatDateBoundaryCellNameSpace.rightLineHeight)
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatDateBoundaryCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatDateBoundaryCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 42,
                   alignment: .center)
    }
    
    struct ChatDateBoundaryCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatDateBoundaryCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
