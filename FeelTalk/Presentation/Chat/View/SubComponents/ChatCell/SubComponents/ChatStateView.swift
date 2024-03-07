//
//  ChatStateView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ChatCellState {
    var isRead: Bool
    var isMine: Bool
    var createAt: String
}

final class ChatStateView: UIStackView {
    let modelObserver = PublishRelay<ChatCellState>()
    private let disposeBag = DisposeBag()
    
    private lazy var isReadLabel: UILabel = {
        let label = UILabel()
        label.text = "안읽음"
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 12.0)
        label.setLineHeight(height: 18.0)
        
        modelObserver
            .map { model -> Bool in model.isRead }
            .bind(to: label.rx.isHidden)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 12.0)
        
        modelObserver
            .map { model -> String in model.createAt }
            .map { createAt -> String in
                let startIndex = createAt.index(createAt.startIndex, offsetBy: 11)
                let endIndex = createAt.index(createAt.startIndex, offsetBy: 15)
                
                let createTime = String(createAt[startIndex...endIndex])
                
                return createTime
            }.bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
}

extension ChatStateView {
    private func addViewSubComponents() {
        [isReadLabel, timeLabel].forEach { addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct ChatStateView_Preview: PreviewProvider {
    static var previews: some View {
        ChatStateView_Presentable()
    }
    
    struct ChatStateView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChatStateView()
            v.modelObserver.accept(ChatCellState(isRead: false, isMine: false, createAt: "2024-01-01T12:00:00"))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
