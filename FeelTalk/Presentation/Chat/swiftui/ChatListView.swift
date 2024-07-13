//
//  ChatListView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI

struct ChatListView: View {
    @ObservedObject private var viewModel: ObservableChatListViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = .init(viewModel)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Text("Hello, World! \(viewModel.outputs.partnerNickname)")
        }
    }
}

private typealias ObservableChatListViewModel = ObservableViewModel<ChatViewModel.Input, ChatViewModel.Output>
extension ObservableChatListViewModel {
    convenience init(_ viewModel: ChatViewModel) {
        self.init(inputs: viewModel.input, outputs: viewModel.output)
        outputs.bind(\.keyboardHeight, value: 0.0)
        outputs.bind(\.inputMode, value: .basics)
        outputs.bind(\.isFunctionActive, value: false)
        outputs.bind(\.partnerNickname, value: "partner")
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView(
            viewModel: ChatViewModel(
                coordinator: nil,
                userUseCase: DefaultUserUseCase(
                    userRepository: DefaultUserRepository()
                ),
                chatUseCase: DefaultChatUseCase(
                    chatRepository: DefaultChatRepository()
                )
            )
        )
    }
}
