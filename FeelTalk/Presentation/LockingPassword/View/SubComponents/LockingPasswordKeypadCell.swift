//
//  LockingPasswordKeypadCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingPasswordKeypadCell: UICollectionViewCell {
    let model = PublishRelay<LockingPasswordKeypadModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: LockingPasswordKeypadCellNameSpace.titleLabelNumberTypeTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.setData(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    private func addSubComponents() { contentView.addSubview(titleLabel) }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension LockingPasswordKeypadCell {
    private func setData(with model: LockingPasswordKeypadModel) {
        titleLabel.rx.text.onNext(model.title)
        
        if model.title == "취소" || model.title == "확인" { titleLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular, size: LockingPasswordKeypadCellNameSpace.titleLabelKRTypeTextSize)) }
        
        if model.title == "확인" { titleLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500)) }
    }
}

#if DEBUG

import SwiftUI

struct LockingPasswordKeypadCell_Previews: PreviewProvider {
    static var previews: some View {
        LockingPasswordKeypadCell_Presentable()
    }
    
    struct LockingPasswordKeypadCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let cell = LockingPasswordKeypadCell()
            cell.model.accept(LockingPasswordKeypadModel(title: "1"))
            
            return cell
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

