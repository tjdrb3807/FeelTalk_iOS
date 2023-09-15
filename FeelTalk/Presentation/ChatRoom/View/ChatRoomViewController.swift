//
//  ChatRoomViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatRoomViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var topBar: ChatRoomTopBar = { ChatRoomTopBar() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    private func setAttributes() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func addSubComponents() {
        addChatRoomViewSubComponents()
        addChatViewSubComponents()
    }
    
    private func setConfigurations() {
        makeChatViewConstraints()
        makeTopBarConstraints()
    }
}

extension ChatRoomViewController {
    private func addChatRoomViewSubComponents() {
        [chatView].forEach { view.addSubview($0) }
    }
    
    private func makeChatViewConstraints() {
        chatView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(121)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func addChatViewSubComponents() {
        [topBar].forEach { chatView.addSubview($0) }
    }
    
    private func makeTopBarConstraints() {
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(topBar.snp.top).offset(60)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatRoomViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct ChatRoomViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            ChatRoomViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
