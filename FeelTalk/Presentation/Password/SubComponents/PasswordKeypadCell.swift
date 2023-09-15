//
//  PasswordKeypadCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordKeypadCell: UICollectionViewCell {
    let model = PublishRelay<KeypadModel>()
    private let dispseBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 20.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.addSubComponent()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.titleLabel.rx.text.onNext(model.title)
            }.disposed(by: dispseBag)
    }
    
    private func addSubComponent() { contentView.addSubview(titleLabel) }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct PasswordKeypadCell_Previews: PreviewProvider {
    static var previews: some View {
        PasswordKeypadCell_Presentable()
    }
    
    struct PasswordKeypadCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PasswordKeypadCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
