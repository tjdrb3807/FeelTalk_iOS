//
//  AdultAuthTimerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthTimerView: UIView {
    let expiradTime = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "03:00"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthTimerViewNameSpace.timerLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponens()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        expiradTime
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        expiradTime
            .map { $0 == "00:00" ? UIColor(named: CommonColorNameSpace.gray500) : UIColor.black }
            .distinctUntilChanged()
            .bind(to: timerLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
    private func addSubComponens() { addSubview(timerLabel) }
    
    private func setConstraints() {
        timerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthTimerView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: AdultAuthTimerViewNameSpace.width,
                   height: AdultAuthTimerViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthTimerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthTimerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
