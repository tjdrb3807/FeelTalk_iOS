//
//  ChatItem.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI

struct StateChatItem: View {
    @State var item: Chat
    @State var prevItem: Chat?
    @State var nextItem: Chat?
    @State var partnerNickname: String
    @State var partnerSignal: Signal
    @State var isPartnerInChat: Bool
    @State var onClickAnswer: (Int) -> Void
    @State var onClickChallenge: (Int) -> Void
    @State var onClickReset: () -> Void
    @State var onClickImage: (ImageChat) -> Void
    
    var body: some View {
        VStack {
            if showPartnerInfo {
                HStack {
                    Image(partnerSignalImageName)
                        .resizable()
                        .frame(width: 28, height: 28)
                    Text("\(partnerNickname)")
                        .font(
                            .custom(CommonFontNameSpace.pretendardRegular, size: 14)
                        )
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.bottom, 4)
            }
            
            HStack(alignment: .bottom) {
                if item.isMine {
                    Spacer()
                    
                    VStack() {
                        Spacer()
                        if showReadText {
                            Text("안읽음")
                        }
                        if showDate {
                            Text("\(formattedDate)")
                        }
                    }
                    .font(
                        .custom(CommonFontNameSpace.pretendardRegular, size: 12)
                    )
                    .foregroundColor(Color("gray_600"))
                    .lineLimit(1)
                }
                
                // item content views by chat type
                switch item.type {
                case .textChatting:
                    let chat = item as! TextChat
                    TextChatItemView(
                        text: chat.text,
                        isMine: chat.isMine
                    )
                case .signalChatting:
                    let chat = item as! SignalChat
                    SignalChatItemView(
                        signalType: chat.signal
                    )
                    .frame(width: 250, height: 296, alignment: .top)
                case .pressForAnswerChatting:
                    let chat = item as! QuestionChat
                    PressForAnswerChatItemView {
                        onClickAnswer(chat.questionIndex)
                    }
                    .frame(width: 250, height: 244, alignment: .top)
                case .resetPartnerPasswordChatting:
                    ResetPartnerPasswordChatItemView {
                        if !item.isMine {
                            onClickReset()
                        }
                    }
                    .frame(width: 250, height: 280, alignment: .top)
                case .challengeChatting, .addChallengeChatting:
                    let chat = item as! ChallengeChat
                    ChallengeChatItemView(
                        chat: chat,
                        onClickButton: {
                            onClickChallenge(chat.challengeIndex)
                        }
                    )
                    .frame(width: 250, height: 308, alignment: .top)
                case .completeChallengeChatting:
                    let chat = item as! ChallengeChat
                    CompleteChallengeChatItemView(chat: chat)
                case .answerChatting:
                    let chat = item as! QuestionChat
                    AnswerChatItemView(
                        chat: chat,
                        onClickButton: {
                            onClickAnswer(chat.questionIndex)
                        }
                    )
                case .questionChatting:
                    let chat = item as! QuestionChat
                    QuestionChatItemView(chat: chat)
                case .imageChatting:
                    let chat = item as! ImageChat
                    ImageChatItemView(
                        chat: chat,
                        onClick: {
                            onClickImage(chat)
                        }
                    )
                case .voiceChatting:
                    let chat = item as! VoiceChat
                    VoiceChatItemView(chat: chat)
                default:
                    EmptyView()
                }
                
                if !item.isMine {
                    VStack() {
                        Spacer()
                        if showDate {
                            Text("\(formattedDate)")
                        }
                    }
                    .font(
                        .custom(CommonFontNameSpace.pretendardRegular, size: 12)
                    )
                    .foregroundColor(Color("gray_600"))
                    .lineLimit(1)
                    
                    Spacer()
                }
            }
        }
        .padding(.top, topPadding)
//        .padding(.bottom, bottomPadding)
        .padding(.leading, leadingPadding)
        .padding(.trailing, trailingPadding)
    }
    
    
    private typealias ObservableChatListViewModel = ObservableViewModel<ChatViewModel.Input, ChatViewModel.Output>

    
    var showPartnerInfo: Bool {
        get {
            !item.isMine && !isMiddle && !isEnd
        }
    }
    
    var partnerSignalImageName: String {
        get {
            "image_signal_\(partnerSignal.type.rawValue)"
        }
    }
    
    var isTopSame: Bool {
        get {
            prevItem != nil
            && item.isMine == prevItem?.isMine
            && getNoSecondDate(item.createAt) == getNoSecondDate(prevItem?.createAt)
        }
    }
    
    var isBottomSame: Bool {
        get {
            nextItem != nil
            && item.isMine == nextItem?.isMine
            && getNoSecondDate(item.createAt) == getNoSecondDate(nextItem?.createAt)
        }
    }
    
    var isStart: Bool { get { !isTopSame && isBottomSame } }
    
    var isMiddle: Bool { get { isTopSame && isBottomSame } }
    
    var isEnd: Bool { get { isTopSame && !isBottomSame } }
    
    var showDate: Bool {
        get {
            !isStart && !isMiddle
        }
    }
    
    var showReadText: Bool {
        get {
            if isPartnerInChat {
                return false
            }
            else if item.isRead {
                return false
            }
            else {
                return !isStart && !isMiddle
            }
        }
    }
    
    var formattedDate: String {
        let date = item.createAt
        guard let dateIndex = date.firstIndex(of: "T") else {
            return date
        }
        let startIndex = date.index(dateIndex, offsetBy: 1)
        guard let endIndex = date.lastIndex(of: ":") else {
            return date
        }
        return String(date[startIndex..<endIndex])
    }
    
    var readText: String {
        get {
            if item.isRead || isStart || isMiddle {
                return ""
            } else {
                return "안읽음"
            }
        }
    }
    
    var topPadding: CGFloat {
        get {
            // middle, end chat
            if isMiddle || isEnd {
                return 4.0
            }
            return 8.0
        }
    }
    
    var bottomPadding: CGFloat {
        get {
            // start, middle chat
            if isStart || isMiddle {
                return 4.0
            }
            return 8.0
        }
    }
    
    var leadingPadding: CGFloat {
        get {
            if item.isMine {
                return 55.0
            } else {
                return 20.0
            }
        }
    }
    
    var trailingPadding: CGFloat {
        get {
            if item.isMine {
                return 20.0
            } else {
                return 55.0
            }
        }
    }
    
    func getNoSecondDate(_ date: String?) -> String? {
        guard let date = date else { return date }
        let startIndex = date.startIndex
        guard let endIndex = date.lastIndex(of: ":") else {
            return date
        }
        return String(date[startIndex..<endIndex])
    }
    
}

struct StateChatItem_Previews: PreviewProvider {
    static var previews: some View {
        StateChatItem(
            item: sampleChatList[21],
            prevItem: nil,
            nextItem: nil,
            partnerNickname: "partner",
            partnerSignal: .init(type: .sexy),
            isPartnerInChat: false,
            onClickAnswer: { _ in },
            onClickChallenge: { _ in },
            onClickReset: { },
            onClickImage: { _ in }
        )
    }
}
