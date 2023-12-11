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

final class ChatStateView: UIStackView {
    private lazy var isReadLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        backgroundColor = .yellow.withAlphaComponent(0.4)
    }
    
    private func addSubComponents() {
        
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
            ChatStateView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
