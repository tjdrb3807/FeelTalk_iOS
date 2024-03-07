//
//  NumberPadViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumberPadViewCell: UICollectionViewCell {
    let modelObserver = PublishRelay<NumberPadCellModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = { UILabel() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        setTitleLabelProperties()
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addCellSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
    }
}

extension NumberPadViewCell {
    private func setTitleLabelProperties() {
        modelObserver
            .asObservable()
            .withUnretained(self)
            .bind { c, model in
                c.titleLabel.rx.text.onNext(model.contentType.rawValue)
                switch model.cellType {
                case .number:
                    c.titleLabel.rx.textColor.onNext(.black)
                    c.titleLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardMedium,
                                                       size: NumberPadViewCellNameSpace.titleLabelNumberTypeTextSize))
                case .function:
                    c.titleLabel.rx.font.onNext(UIFont(name: CommonFontNameSpace.pretendardRegular,
                                                       size: NumberPadViewCellNameSpace.titleLabelFunctionTypeTextSize))
                    if model.contentType == .cancel {
                        c.titleLabel.rx.textColor.onNext(.black)
                    } else if model.contentType == .confirm {
                        c.titleLabel.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.main500))
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func addCellSubComponents() { contentView.addSubview(titleLabel) }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
#if DEBUG

import SwiftUI

struct NumberPadViewCell_Previews: PreviewProvider {
    static var previews: some View {
        NumberPadViewCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width / 3,
                   height: NumberPadViewCellNameSpace.height,
                   alignment: .center)
    }
    
    struct NumberPadViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = NumberPadViewCell()
            c.modelObserver.accept(NumberPadCellModel(cellType: .function, contentType: .confirm))
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
