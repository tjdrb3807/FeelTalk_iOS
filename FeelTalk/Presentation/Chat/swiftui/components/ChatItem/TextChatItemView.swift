//
//  TextChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import SwiftUI

struct TextChatItemView: View {
    @State var text: String
    @State var isMine: Bool
    
    var body: some View {
        Text(text)
            .font(
                .custom(CommonFontNameSpace.pretendardRegular, size: 16)
            )
            .foregroundColor(textColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(backgroundColor)
            .cornerRadius(16)
    }
    
    var textColor: Color {
        get {
            if isMine {
                return Color.white
            } else {
                return Color.black
            }
        }
    }
    
    var backgroundColor: Color {
        get {
            if isMine {
                return Color(CommonColorNameSpace.main500)
            } else {
                return Color(CommonColorNameSpace.gray100)
            }
        }
    }
}

struct TextChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        TextChatItemView(
            text: "test",
            isMine: true
        )
    }
}
