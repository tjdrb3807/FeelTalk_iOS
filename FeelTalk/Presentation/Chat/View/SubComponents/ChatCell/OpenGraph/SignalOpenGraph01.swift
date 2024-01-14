//
//  SignalOpenGraph01.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignalOpenGraph01: UIView {
    let model = PublishRelay<SignalType>()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12.0
        stackView.backgroundColor = .red.withAlphaComponent(0.3)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     두근두근 💘
                     연인이 시그널을 보냈어요
                     """
        label.setLineHeight(height: 24.0)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 16.0)

        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind (){
        
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConsgtraints()
    }
}

extension SignalOpenGraph01 {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConsgtraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension SignalOpenGraph01 {
    
}

#if DEBUG

import SwiftUI

struct SignalOpenGraph01_Previews: PreviewProvider {
    static var previews: some View {
        SignalOpenGraph01_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 250,
                   height: 230,
                   alignment: .center)
    }
    
    struct SignalOpenGraph01_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            SignalOpenGraph01()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}


#endif
