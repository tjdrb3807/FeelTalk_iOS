//
//  ChatListView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI
import RxSwift

struct ChatListView: View {
    @Namespace var bottomId
    @State var bottomSpacerId = 0
    
    @State private var originalViewModel: ChatViewModel
    @ObservedObject private var viewModel: ObservableChatListViewModel
    @State var bottomOffset: CGFloat
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var showAlert = false
    @State private var alertType: AlertType = .empty
    
    
    init(viewModel: ChatViewModel, bottomOffset: CGFloat) {
        self.viewModel = .init(viewModel)
        self.originalViewModel = viewModel
        self.bottomOffset = bottomOffset
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    if !viewModel.outputs.isLastPage {
                        ProgressView()
                    }
                    
                    if viewModel.outputs.showTodayDivider {
                        DividerChatItemView(
                            date: todayDate
                        )
                        .padding(.top, 8)
                        .id(viewModel.outputs.showTodayDivider)
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
                            isPartnerInChat: viewModel.outputs.isPartnerInChat,
                            onClickAnswer: { questionIndex in
                                originalViewModel.navigateToAnswer(
                                    questionIndex: questionIndex
                                )
                            },
                            onClickChallenge: { challengeIndex in
                                Task {
                                    let isSuccessful =
                                    await originalViewModel.navigateToChallenge(
                                        challengeIndex: challengeIndex
                                    )
                                    if !isSuccessful {
                                        self.alertType = .deletedChallenge
                                        self.showAlert = true
                                    }
                                }
                            },
                            onClickReset: {
                                Task {
                                    do {
                                        let isExpired = try await originalViewModel.resetPartnerPassword(chatIndex: currentItem.index)
                                        
                                        if isExpired {
                                            self.alertType = .alreadyDone
                                            self.showAlert = true
                                        } else {
                                            self.alertType = .success
                                            self.showAlert = true
                                        }
                                    } catch {
                                        print("resetPartnerPassword error: \(error)")
                                        self.alertType = .failure
                                        self.showAlert = true
                                    }
                                }
                            },
                            onClickImage: { imageChat in
                                originalViewModel.navigateToImageDetail(chat: imageChat)
                            }
                        )
                        .id("\(currentItem.index)_\(currentItem.updateCount)")
                    }
                    
                    Spacer()
                        .frame(height: 16)
                        .id(bottomSpacerId)
                        .onAppear {
                            bottomSpacerId += 1
                        }
                    
                    Spacer()
                        .frame(height: 0)
                        .id(bottomId)
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
                if let last = viewModel.outputs.chatList.last {
                    let id = "\(last.index)_\(last.updateCount)"

                    proxy.scrollTo(id, anchor: UnitPoint(x: 0, y: 16))
                } else {
                    proxy.scrollTo(bottomId)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .success:
                return Alert(
                    title: Text("연인 돕기 완료!"),
                    message: Text("연인이 암호를 재설정하러 갔어요.\n곧 필로우톡에서 만나요!"),
                    dismissButton: .default(Text("확인"))
                )
            case .alreadyDone:
                return Alert(
                    title: Text("이미 연인을 도왔어요"),
                    message: Text("이전에 연인을 도와 준 경험이 있어요.\n한 번 요청할 때 한 번 도울 수 있어요."),
                    dismissButton: .default(Text("확인"))
                )
            case .failure, .empty:
                return Alert(
                    title: Text("에러"),
                    message: Text("연인의 암호를 해제하는데 실패했어요."),
                    dismissButton: .default(Text("확인"))
                )
            case .deletedChallenge:
                return Alert(
                    title: Text("앗! 챌린지를 찾을 수 없어요😅"),
                    message: Text("이미 삭제된 챌린지예요."),
                    dismissButton: .default(Text("확인"))
                )
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


enum AlertType {
    case success, alreadyDone, failure, empty, deletedChallenge
}


private typealias ObservableChatListViewModel = ObservableViewModel<ChatViewModel.Input, ChatViewModel.Output>
extension ObservableChatListViewModel {
    convenience init(_ viewModel: ChatViewModel) {
        self.init(inputs: viewModel.input, outputs: viewModel.output)
        
        outputs.bind(\.partnerNickname, value: "")
        outputs.bind(\.partnerSignal, value: .init(type: .sexy))
        outputs.bind(\.chatList, value: [])
        outputs.bind(\.scrollToBottomCount, value: 0)
        outputs.bind(\.showTodayDivider, value: false)
        outputs.bind(\.isLastPage, value: false)
        outputs.bind(\.isLoadingChatList, value: true)
        outputs.bind(\.isPartnerInChat, value: false)
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
