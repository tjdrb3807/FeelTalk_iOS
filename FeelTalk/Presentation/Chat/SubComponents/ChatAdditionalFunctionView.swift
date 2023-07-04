//
//  ChatAdditionalFunctionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/03.
//
import UIKit
import SnapKit

class ChatAdditionalFunctionView: BaseView {
    private lazy var fullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var pushCameraViewButton = ChatAdditionalFunctionButton(additionalFunctionType: .camera)
    private lazy var pushAlbumViewButton = ChatAdditionalFunctionButton(additionalFunctionType: .album)
    
    override func setAttribute() {
        backgroundColor = UIColor(named: "gray_100")
    }
    
    override func addSubViews() {
        [pushCameraViewButton, pushAlbumViewButton].forEach { fullHorizontalStackView.addArrangedSubview($0) }
        
        addSubview(fullHorizontalStackView)
    }
    
    override func setConfig() {
        [pushCameraViewButton, pushAlbumViewButton].forEach { button in
            button.snp.makeConstraints { $0.width.equalTo((UIScreen.main.bounds.width / 100) * 23.46) }
        }
        
        fullHorizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 17.06)
            $0.centerY.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 14.40)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatAdditionalFunctionView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAdditionalFunctionView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChatAdditionalFunctionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatAdditionalFunctionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
