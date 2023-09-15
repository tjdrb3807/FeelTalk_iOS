//
//  TextCountingView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TextCountingView: UIStackView {
    private var denominator: Int
    let molecularCount = BehaviorRelay<Int>(value: 0)
    let disposeBag = DisposeBag()
    
    lazy var molecularLabel: UILabel = {
        let label = UILabel()
        label.text = TextCountingViewNameSpace.molecularLabelDefaultText
        label.textColor = UIColor(named: TextCountingViewNameSpace.molecularLabelDefaultTextColor)
        label.textAlignment = .right
        label.font = UIFont(name: TextCountingViewNameSpace.labelTextFont,
                            size: TextCountingViewNameSpace.labelTextSize)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var slashLabel: UILabel = {
        let label = UILabel()
        label.text = TextCountingViewNameSpace.slashLabelText
        label.textColor = UIColor(named: TextCountingViewNameSpace.labelTextColor)
        label.textAlignment = .right
        label.font = UIFont(name: TextCountingViewNameSpace.labelTextFont,
                            size: TextCountingViewNameSpace.labelTextSize)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var denominatorLabel: UILabel = {
        let label = UILabel()
        label.text = String(denominator)
        label.textColor = UIColor(named: TextCountingViewNameSpace.labelTextColor)
        label.textAlignment = .right
        label.font = UIFont(name: TextCountingViewNameSpace.labelTextFont,
                            size: TextCountingViewNameSpace.labelTextSize)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    init(denominator: Int) {
        self.denominator = denominator
        super.init(frame: .zero)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        molecularCount
            .withUnretained(self)
            .bind { v, count in
                v.updateMolecularLabelText(count: count)
                v.updateMolecularLabelColor(count: count)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    private func addSubComponents() {
        [molecularLabel, slashLabel, denominatorLabel].forEach { addArrangedSubview($0) }
    }
}

// MARK: Update UI setting method.
extension TextCountingView {
    public func updateMolecularLabelColor(count: Int) {
        count == denominator ? molecularLabel.rx.textColor.onNext(UIColor(named: TextCountingViewNameSpace.molecularLabelUpdateTextColor)) : molecularLabel.rx.textColor.onNext(UIColor(named: TextCountingViewNameSpace.molecularLabelDefaultTextColor))
    }
    
    public func updateMolecularLabelText(count: Int) { molecularLabel.rx.text.onNext(String(count)) }
}

#if DEBUG

import SwiftUI

struct TextCountingView_Previews: PreviewProvider {
    static var previews: some View {
        TextCountingView_Presentable()
    }
    
    struct TextCountingView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            TextCountingView(denominator: 20)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
