//
//  CompletedChallengeOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/03/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CompletedChallengeOpenGraph: UIView {
    private lazy var totalContentStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    private lazy var firecrackerImage: UIImageView = { UIImageView() }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: 250.0,
                height: 244.0)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        
    }
    
    private func setConstraints() {
        
    }
}

#if DEBUG

import SwiftUI

struct CompletedChallengeOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        CompletedChallengeOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 250.0,
                height: 244.0,
                alignment: .center)
    }
    
    struct CompletedChallengeOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CompletedChallengeOpenGraph()
            
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
