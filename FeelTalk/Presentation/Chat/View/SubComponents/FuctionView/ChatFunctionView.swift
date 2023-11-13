//
//  ChatFunctionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatFunctionView: UIView {
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        
        return view
    }()
    
    lazy var cameraFunctionButton: ChatFunctionButton = { ChatFunctionButton(type: .camera) }()
    
    lazy var albumFunctionButton: ChatFunctionButton = { ChatFunctionButton(type: .album) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        addFucntionViewSubComponents()
        addContentViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentViewConstraints()
        makeCameraFunctionButtonConstraints()
        makeAlbumFunctionButtonConstraints()
    }
}

extension ChatFunctionView {
    private func addFucntionViewSubComponents() { addSubview(contentView) }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChatFunctionViewNameSpace.height)
        }
    }
    
    private func addContentViewSubComponents() {
        [cameraFunctionButton, albumFunctionButton].forEach { contentView.addSubview($0) }
    }
    
    private func makeCameraFunctionButtonConstraints() {
        cameraFunctionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChatFunctionViewNameSpace.buttonTopInset)
            $0.leading.equalToSuperview().inset(ChatFunctionViewNameSpace.cameraFunctionButtonLeadingInset)
            $0.width.equalTo(ChatFunctionButtonNameSpace.width)
        }
    }
    
    private func makeAlbumFunctionButtonConstraints() {
        albumFunctionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChatFunctionViewNameSpace.buttonTopInset)
            $0.trailing.equalToSuperview().inset(ChatFunctionViewNameSpace.albumFunctionButtonTrailingInset)
            $0.width.equalTo(ChatFunctionButtonNameSpace.width)
        }
    }
}

extension ChatFunctionView {
    public func showWithAnimation(completion: @escaping () -> Void = {}) {
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChatFunctionViewNameSpace.height)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: self.layoutIfNeeded)
    }
    
    public func showNoAnimation() {
        
    }
}

#if DEBUG

import SwiftUI

struct ChatFunctionView_Previews: PreviewProvider {
    static var previews: some View {
        ChatFunctionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChatFunctionViewNameSpace.height,
                   alignment: .bottom)
    }
    
    struct ChatFunctionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChatFunctionView()
            v.showWithAnimation()
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
