//
//  QuestionChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI

struct QuestionChatItemView: View {
    @State var chat: QuestionChat
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image("image_question_open_graph")
                .frame(width: 72, height: 72)
            
            VStack(alignment: .center, spacing: 2) {
                VStack {
                    Text("Q. \(chat.question?.header ?? "")")
                    Text(chat.question?.body ?? "")
                }
                .font(
                    Font.custom(CommonFontNameSpace.pretendardRegular, size: 14)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 226, alignment: .bottom)
                
                Text(formattedDate)
                  .font(
                    Font.custom(CommonFontNameSpace.pretendardRegular, size: 12)
                  )
                  .foregroundColor(Color("gray_500"))
            }
            .padding(0)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("연인의 답변")
                  .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
                  .foregroundColor(Color("gray_600"))
                  .frame(width: 178, alignment: .leading)
                
                Text(chat.question?.partnerAnser ?? "")
                  .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 14))
                  .foregroundColor(.black)
                  .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("나의 답변")
                  .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
                  .foregroundColor(Color("gray_600"))
                  .frame(width: 178, alignment: .leading)
                
                Text(chat.question?.myAnser ?? "")
                  .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 14))
                  .foregroundColor(.black)
                  .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
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
            guard let dateString = chat.question?.createAt else {
                return ""
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = dateFormatter.date(from: dateString) else {
                return dateString
            }
            
            let questionDateFormatter = DateFormatter()
            questionDateFormatter.dateFormat = "yyyy.MM.dd"
            return questionDateFormatter.string(from: date)
        }
    }
}

struct QuestionChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionChatItemView(
            chat: QuestionChat(
                index: 20,
                type: .answerChatting,
                isRead: false,
                isMine: true,
                createAt: "2024-01-01T12:00:00",
                questionIndex: 0,
                question: Question(
                    index: 10,
                    pageNo: 0,
                    title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
                    header: "난 이게 가장 좋더라!",
                    body: "당신이 가장 좋아하는 스킨십은?",
                    highlight: [0],
                    myAnser: nil,
                    partnerAnser: nil,
                    isMyAnswer: false,
                    isPartnerAnswer: false,
                    createAt: "2024-01-01T12:00:00"
                )
            )
        )
    }
}
