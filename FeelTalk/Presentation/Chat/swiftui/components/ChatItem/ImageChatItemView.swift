//
//  ImageChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI

struct ImageChatItemView: View {
    @State var chat: ImageChat
    @State var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                Image(uiImage: chat.uiImage ?? UIImage())
                .resizable()
                .scaledToFit()
            }
            .frame(maxWidth: imageWidth, maxHeight: imageHeight)
            .cornerRadius(16)
        }
    }
    
    let maxWidth = 252.0
    let maxHeight = 300.0
    
    var imageWidth: CGFloat {
        get {
            guard let width = chat.uiImage?.cgImage?.width else {
                return maxWidth
            }
            guard let height = chat.uiImage?.cgImage?.height else {
                return maxWidth
            }
            
            let maxRatio = maxWidth / maxHeight
            let imageRatio = CGFloat(width) / CGFloat(height)
            
            // width > height
            if imageRatio > maxRatio {
                return maxWidth
            } else {
                return CGFloat(width) * (maxHeight / CGFloat(height))
            }
        }
    }
    
    var imageHeight: CGFloat {
        get {
            guard let width = chat.uiImage?.cgImage?.width else {
                return maxHeight
            }
            guard let height = chat.uiImage?.cgImage?.height else {
                return maxHeight
            }
            
            let maxRatio = maxWidth / maxHeight
            let imageRatio = CGFloat(width) / CGFloat(height)
            
            // width > height
            if imageRatio > maxRatio {
                return CGFloat(height) * (maxWidth / CGFloat(width))
            } else {
                return maxHeight
            }
        }
    }
}

struct ImageChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImageChatItemView(
            chat: ImageChat(
                index: 10,
                type: .imageChatting,
                isRead: false,
                isMine: true,
                createAt: "2024-01-01T12:00:00",
                imageURL: "",
                uiImage: UIImage(named: "test2") ?? UIImage()
            ),
            onClick: {}
        )
    }
}
