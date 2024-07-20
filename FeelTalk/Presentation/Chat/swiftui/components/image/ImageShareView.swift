//
//  ImageDetailView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/20.
//

import SwiftUI
import RxSwift

enum ImageShareAlertType {
    case error, bigSizeImage
}

struct ImageShareView: View {
    @State var image: UIImage
    @State var onBack: () -> Void
    
    @State var alertType: ImageShareAlertType = .error
    @State var showAlert = false
    @State var isLoading = false
    
    private let chatUseCase = DefaultChatUseCase(chatRepository: DefaultChatRepository())
    private let disposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Color.black
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                    .preferredColorScheme(.light)
                
                ZStack {
                    ZoomableScrollView {
                        Image(uiImage: image)
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
                                    Image("icon_white_right_arrow")
                                        .frame(width: 24, height: 24)
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .padding(12)
                                .frame(width: 48, height: 48, alignment: .center)
                            }
                            
                            Spacer()
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    .frame(height: 48, alignment: .center)
                                    .padding(.trailing, 12)
                            } else {
                                Button {
                                    shareImage()
                                } label: {
                                    HStack(alignment: .center, spacing: 0) {
                                        Text("전송")
                                          .font(
                                            Font.custom(CommonFontNameSpace.pretendardMedium, size: 18)
                                          )
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(.white)
                                          .padding(.vertical, 10)
                                          .padding(.horizontal, 8)
                                    }
                                    .frame(height: 48, alignment: .center)
                                    .padding(.trailing, 12)
                                }
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
            switch alertType {
            case .error:
                return Alert(
                    title: Text("에러"),
                    message: Text("이미지를 전송하는데 실패했어요."),
                    dismissButton: .default(Text("확인"))
                )
            case .bigSizeImage:
                return Alert(
                    title: Text("이미지를 전송할 수 없어요"),
                    message: Text("이미지의 크기가 너무 커요."),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
    
    private func shareImage() {
        if isLoading {
            return
        }
        
        Task {
            isLoading = true
            
            guard let jpeg = image.jpegData(compressionQuality: 1) else { return }
            let data = NSData(data: jpeg)
            let imageSize = Double(data.count) / (1024 * 1024)
            print("imageSize: \(imageSize) MB")
            
            if imageSize > 50.0 {
                isLoading = false
                alertType = .bigSizeImage
                showAlert = true
                return
            }
            
            self.chatUseCase.sendImageChat(image: image)
                .asObservable()
                .subscribe(onNext: { imageChat in
                    isLoading = false
                    onBack()
                    FCMHandler.shared.chatObservable.accept(imageChat)
                }, onError: { error in
                    isLoading = false
                    alertType = .error
                    showAlert = true
                }).disposed(by: disposeBag)
        }
    }
    
    
}

struct ImageShareView_Previews: PreviewProvider {
    static var previews: some View {
        ImageShareView(
            image: UIImage(named: "test1") ?? UIImage(),
            onBack: {}
        )
    }
}
