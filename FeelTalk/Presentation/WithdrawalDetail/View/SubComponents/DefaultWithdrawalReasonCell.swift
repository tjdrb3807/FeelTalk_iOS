//
//  DefaultWithdrawalReasonCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DefaultWithdrawalReasonCell: UITableViewCell {
    let type = PublishRelay<WithdrawalReasonType>()
    let isSeelcted = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0.0,
                                                                     left: 0.0,
                                                                     bottom: 5.0,
                                                                     right: 0.0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        type
            .map { $0.rawValue }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        isSeelcted
            .withUnretained(self)
            .bind { v, state in
                v.toggleCheckImageView(state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor(named: CommonColorNameSpace.gray300)?.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.layer.cornerRadius = 12.0
        contentView.clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeCheckImageViewConstraints()
        makeTitleLabelConstraints()
    }
}

extension DefaultWithdrawalReasonCell {
    private func addViewSubComponents() {
        [checkImageView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeCheckImageViewConstraints() {
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12.0)
            $0.width.equalTo(24.0)
            $0.height.equalTo(checkImageView.snp.width)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImageView.snp.trailing).offset(12.0)
        }
    }
}

extension DefaultWithdrawalReasonCell {
    private func toggleCheckImageView(_ state: Bool) {
        state ?
        checkImageView.rx.image.onNext(UIImage(named: "icon_circle_check_able")) :
        checkImageView.rx.image.onNext(UIImage(named: "icon_circle_check_unable"))
    }
}

#if DEBUG

import SwiftUI

struct DefaultWithdrawalReasionCell_Previews: PreviewProvider {
    static var previews: some View {
        DefaultWithdrawalReasonCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 61,
                   alignment: .center)
    }
    
    struct DefaultWithdrawalReasonCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = DefaultWithdrawalReasonCell()
            view.type.accept(.breakUp)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
