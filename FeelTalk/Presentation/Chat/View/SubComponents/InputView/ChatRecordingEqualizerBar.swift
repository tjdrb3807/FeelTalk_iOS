//
//  ChatRecordingEqualizerBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatRecordingEqualizerBar: UIView {
    var height = BehaviorRelay<CGFloat>(value: CommonConstraintNameSpace.verticalRatioCalculator * 0.98)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        height
            .withUnretained(self)
            .bind { v, height in
                v.snp.remakeConstraints { $0.height.equalTo(height) }
            }.disposed(by: disposeBag)            
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main400)
        layer.cornerRadius = ChatRecordingEqulizerBarNameSpace.cornerRadius
    }
}

#if DEBUG

import SwiftUI

struct ChatRecordingEqualizerBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatRecordingEqualizerBar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: ChatRecordingEqulizerBarNameSpace.width,
                   height: ChatRecordingEqulizerBarNameSpace.defaultHeight,
                   alignment: .center)
    }
    
    struct ChatRecordingEqualizerBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatRecordingEqualizerBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
