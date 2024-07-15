//
//  ChatListView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI
import RxSwift

struct ChatListView: View {
    @State private var originalViewModel: ChatViewModel
    @ObservedObject private var viewModel: ObservableChatListViewModel
    @State var bottomOffset: CGFloat
    
    @Namespace var bottomID
    
    init(viewModel: ChatViewModel, bottomOffset: CGFloat) {
        self.viewModel = .init(viewModel)
        self.originalViewModel = viewModel
        self.bottomOffset = bottomOffset
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(
                        viewModel.outputs.chatList.indices,
                        id: \.self
                    ) { index in
                        let currentItem = viewModel.outputs.chatList[index]
                        let prevItem = getPrevChat(index: index)
                        
                        if prevItem == nil || getNoTimeDate(currentItem.createAt) != getNoTimeDate(prevItem?.createAt) {
                            
                            DividerChatItemView(
                                date: currentItem.createAt
                            )
                            .padding(.top, 8)
                        }
                        
                        StateChatItem(
                            item: currentItem,
                            prevItem: prevItem,
                            nextItem: getNextChat(index: index),
                            partnerNickname: viewModel.outputs.partnerNickname,
                            partnerSignal: viewModel.outputs.partnerSignal,
                            onClickAnswer: { questionIndex in
                                originalViewModel.navigateToAnswer(
                                    questionIndex: questionIndex
                                )
                            },
                            onClickChallenge: { challengeIndex in
                                originalViewModel.navigateToChallenge(
                                    challengeIndex: challengeIndex
                                )
                            },
                            onClickReset: {
                                originalViewModel.resetPartnerPassword()
                            },
                            onClickImage: { imageChat in
                                originalViewModel.navigateToImage(chat: imageChat)
                            }
                        )
                        .id(index)
                    }
                    Spacer()
                        .frame(height: 16)
                        .id(bottomID)
                }
            }
            .onAppear {
                if let idx = viewModel.outputs.chatList.last?.index {
                    proxy.scrollTo(idx)
                } else {
                    proxy.scrollTo(bottomID)
                }
            }
            .onChange(
                of: viewModel.outputs.scrollToBottomCount
            ) { _ in
                if let idx = viewModel.outputs.chatList.last?.index {
                    proxy.scrollTo(idx)
                } else {
                    proxy.scrollTo(bottomID)
                }
            }
        }
    }
    
    func getPrevChat(index: Int) -> Chat? {
        let prevIndex = index - 1
        if prevIndex < 0 {
            return nil
        } else {
            return viewModel.outputs.chatList[prevIndex]
        }
    }
    
    func getNextChat(index: Int) -> Chat? {
        let nextIndex = index + 1
        if nextIndex >= viewModel.outputs.chatList.count {
            return nil
        } else {
            return viewModel.outputs.chatList[nextIndex]
        }
    }
    
    func getNoTimeDate(_ date: String?) -> String? {
        guard let date = date else { return date }
        let startIndex = date.startIndex
        guard let endIndex = date.lastIndex(of: "T") else {
            return date
        }
        return String(date[startIndex..<endIndex])
    }
}

private typealias ObservableChatListViewModel = ObservableViewModel<ChatViewModel.Input, ChatViewModel.Output>
extension ObservableChatListViewModel {
    convenience init(_ viewModel: ChatViewModel) {
        self.init(inputs: viewModel.input, outputs: viewModel.output)
        
        outputs.bind(\.partnerNickname, value: "partner")
        outputs.bind(\.partnerSignal, value: .init(type: .sexy))
        outputs.bind(\.chatList, value: sampleChatList)
        outputs.bind(\.scrollToBottomCount, value: 0)
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
                ),
                signalUseCase: DefaultSignalUseCase(
                    signalRepositroy: DefaultSignalRepository()
                )
            ),
            bottomOffset: 0
        )
    }
}
