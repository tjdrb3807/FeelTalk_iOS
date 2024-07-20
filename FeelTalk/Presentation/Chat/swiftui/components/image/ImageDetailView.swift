//
//  ImageDetailView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/20.
//

import SwiftUI

struct ImageDetailView: View {
    @State var chat: ImageChat
    @State var ownerNickname: String
    @State var ownerSignal: Signal
    @State var onBack: () -> Void
    
    @State var showAlert = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Color.black
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                    .preferredColorScheme(.light)
                
                ZStack {
                    ZoomableScrollView {
                        Image(uiImage: chat.uiImage ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(alignment: .center)
                    }
                    
                    VStack {
                        HStack {
                            Button {
                                onBack()
                            } label: {
                                HStack(alignment: .center, spacing: 0) {
                                    Image("icon_cancel_white")
                                        .frame(width: 24, height: 24)
                                }
                                .padding(12)
                                .frame(width: 48, height: 48, alignment: .center)
                            }
                            
                            HStack(alignment: .center, spacing: 8) {
                                Image(signalImageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(ownerNickname)
                                        .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 16))
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(Color.white)
                                    
                                    Text(formattedDate)
                                      .font(Font.custom(CommonFontNameSpace.pretendardRegular, size: 12))
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(Color.white.opacity(0.7))
                                }
                                .padding(0)
                            }
                            .padding(0)
                            
                            Spacer()
                            
                            Button {
                                saveImageToAlbum()
                            } label: {
                                HStack(alignment: .center, spacing: 0) {
                                    Image("icon_download")
                                      .frame(width: 24, height: 24)
                                }
                                .padding(12)
                                .frame(width: 48, height: 48, alignment: .center)
                            }
                        }
                        .frame(height: 60, alignment: .center)
                        .background(Color.black.opacity(0.5))
                        
                        Spacer()
                    }
                }
                .background(Color.black)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("이미지를 다운했습니다."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    
    var signalImageName: String {
        "image_signal_\(ownerSignal.type.rawValue)"
    }
    
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let dateObj = dateFormatter.date(from: chat.createAt) else {
            return chat.createAt
        }
        
        let dividerDateFormatter = DateFormatter()
        dividerDateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return dividerDateFormatter.string(from: dateObj)
    }
    
    func saveImageToAlbum() {
        if let image = chat.uiImage {
            Task {
                ImageSaver {
                    showAlert = true
                }.writeToPhotoAlbum(image: image)
            }
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(
            chat: ImageChat(
                index: 10,
                type: .imageChatting,
                isRead: false,
                isMine: true,
                createAt: "2024-01-02T12:00:00",
                imageURL: "",
                uiImage: UIImage(named: "test1")
            ),
            ownerNickname: "nickname",
            ownerSignal: Signal(type: .love),
            onBack: {}
        )
    }
}
