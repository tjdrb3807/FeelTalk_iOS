//
//  CompleteChallengeChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI

struct CompleteChallengeChatItemView: View {
    @State var chat: ChallengeChat
    
    var body: some View {
        VStack(alignment: .center) {
            Image("image_complete_challenge")
            
            Text("챌린지를 멋지게 완료했어요!")
                .font(
                    Font.custom(CommonFontNameSpace.pretendardMedium, size: 16)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.vertical, 12)
            
            VStack(alignment: .center, spacing: 8) {
                Text(chat.challengeTitle)
                    .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                
                Text(formattedDate)
                    .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("gray_600"))
                    .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white)
            .cornerRadius(8)
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(width: 250, alignment: .top)
        .background(Color("gray_100"))
        .cornerRadius(16)
    }
    
    var formattedDate: String {
        get {
            let dateString = chat.challenge?.completeDate ?? chat.challengeDeadline
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
            guard let date = dateFormatter.date(from: dateString) else {
                return dateString
            }
            
            let completeDateFormatter = DateFormatter()
            completeDateFormatter.dateFormat = "yyyy년 M월 d일 성공"
            return completeDateFormatter.string(from: date)
        }
    }
}

struct CompleteChallengeChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteChallengeChatItemView(
            chat: ChallengeChat(
                index: 16,
                type: .completeChallengeChatting,
                isRead: false,
                isMine: true,
                createAt: "2024-01-01T12:00:00",
                challengeIndex: 0,
                challengeTitle: "challenge title challenge title challenge title challenge title",
                challengeDeadline:"2024-01-01T12:00:00",
                challenge: Challenge(
                    index: 0,
                    pageNo: 0,
                    title: "테스트 제목입니다.",
                    deadline: "2024-01-23T10:00:00",
                    content: "Hello",
                    creator: "KakaoSG",
                    isCompleted: false
                )
            )
        )
    }
}
