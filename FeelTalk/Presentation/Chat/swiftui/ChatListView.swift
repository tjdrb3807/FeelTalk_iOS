//
//  ChatListView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI
import RxSwift

struct ChatListView: View {
    @Namespace var bottomID
    
    @State private var originalViewModel: ChatViewModel
    @ObservedObject private var viewModel: ObservableChatListViewModel
    @State var bottomOffset: CGFloat
    
    @State private var scrollPosition: CGPoint = .zero
    
    
    init(viewModel: ChatViewModel, bottomOffset: CGFloat) {
        self.viewModel = .init(viewModel)
        self.originalViewModel = viewModel
        self.bottomOffset = bottomOffset
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
//                    if !viewModel.outputs.isLastPage {
//                        ProgressView()
//                    }
                    
                    if viewModel.outputs.showTodayDivider {
                        DividerChatItemView(
                            date: todayDate
                        )
                        .padding(.top, 8)
                    }
                    
                    ForEach(
                        viewModel.outputs.chatList.indices,
                        id: \.self
                    ) { index in
                        let currentItem = viewModel.outputs.chatList[index]
                        let prevItem = getPrevChat(index: index)
                        
                        if (viewModel.outputs.isLastPage && prevItem == nil)
                            || (prevItem != nil && getNoTimeDate(currentItem.createAt) != getNoTimeDate(prevItem?.createAt)) {
                            
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
                        .id(currentItem.index)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                        .id(bottomID)
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scroll")).origin
                            )
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    //https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b
                    self.scrollPosition = value
                    if !viewModel.outputs.isLoadingChatList && value.y >= -500.0 {
                        originalViewModel.loadNextPageChatList()
                    }
                }
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .coordinateSpace(name: "scroll")
            .onChange(
                of: viewModel.outputs.scrollToBottomCount
            ) { _ in
                if let idx = viewModel.outputs.chatList.last?.index {
                    proxy.scrollTo(viewModel.outputs.chatList[idx].index)
                } else {
                    proxy.scrollTo(bottomID)
                }
            }
        }
    }
    
    var todayDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return dateFormatter.string(from: Date())
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
        outputs.bind(\.chatList, value: [])
        outputs.bind(\.scrollToBottomCount, value: 0)
        outputs.bind(\.showTodayDivider, value: false)
        outputs.bind(\.isLastPage, value: false)
        outputs.bind(\.isLoadingChatList, value: true)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
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
                ),
                questionUseCase: DefaultQuestionUseCase(
                    questionRepository: DefaultQuestionRepository(),
                    userRepository: DefaultUserRepository()
                ),
                challengeUseCase: DefaultChallengeUseCase(
                    challengeRepository: DefaultChallengeRepository()
                )
            ),
            bottomOffset: 0
        )
    }
}
