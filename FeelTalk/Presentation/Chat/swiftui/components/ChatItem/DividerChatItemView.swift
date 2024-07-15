//
//  DividerChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI

struct DividerChatItemView: View {
    @State var date: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
              .background(Color("main_300"))
            
            Text(formattedDate)
                .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
              .multilineTextAlignment(.center)
              .foregroundColor(Color("gray_500"))
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
              .background(Color("main_300"))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }
    
    var formattedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
            guard let dateObj = dateFormatter.date(from: date) else {
                return date
            }
            
            let dividerDateFormatter = DateFormatter()
            dividerDateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dividerDateFormatter.string(from: dateObj)
        }
    }
}

struct DividerChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        DividerChatItemView(
            date: "2024-01-01T12:00:00"
        )
    }
}
