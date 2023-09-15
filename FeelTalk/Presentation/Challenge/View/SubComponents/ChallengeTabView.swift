//
//  ChallengeTabView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeTabView: UIView {
    private let items: [ChallengeTabType] = ChallengeTabType.allCases
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    
    var didTap: ((Int) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        items
            .enumerated()
            .forEach { offset, type in
                let item = ChallengeTabItem(type: type)
                item.tag = offset
                stackView.addArrangedSubview(item)
            }
    }
    
    private func addSubComponents() {
        addSubview(stackView)
    }
    
    private func setConfiguration() {
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTabView_Presentable()
    }
    
    struct ChallengeTabView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeTabView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
