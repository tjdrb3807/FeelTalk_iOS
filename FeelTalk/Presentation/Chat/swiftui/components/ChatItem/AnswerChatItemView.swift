//
//  AnswerChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI

struct AnswerChatItemView: View {
    @State var chat: QuestionChat
    @State var onClickButton: () -> Void
    
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
                .fixedSize(horizontal: false, vertical: true)
                
                Text(formattedDate)
                  .font(
                    Font.custom(CommonFontNameSpace.pretendardRegular, size: 12)
                  )
                  .foregroundColor(Color("gray_500"))
            }
            .padding(0)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("연인이 답변을 기다리고 있어요. \n아래의 버튼을 눌러 \n오늘의 질문에 답해보세요!")
                  .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color("gray_600"))
                  .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(8)
            
            Button {
                onClickButton()
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Text("답변하기")
                      .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 16))
                      .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("main_500"))
                .cornerRadius(50)
            }
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

struct AnswerChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerChatItemView(
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
            ),
            onClickButton: {}
        )
    }
}
