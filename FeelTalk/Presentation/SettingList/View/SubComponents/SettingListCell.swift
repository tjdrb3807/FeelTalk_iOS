//
//  SettingListCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingListCell: UITableViewCell {
    let model = PublishRelay<SettingListModel>()
    private lazy var disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SettingListCellNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SettingListCellNameSpace.stateLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var rightArrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SettingListCellNameSpace.rightArrowIconImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .map { $0.type }
            .withUnretained(self)
            .bind { v, type in
                v.titleLabel.rx.text.onNext(type.rawValue)
            }.disposed(by: disposeBag)
        
        model
            .filter { $0.type == .lcokTheScreen }
            .map { $0.state }
            .withUnretained(self)
            .bind { v, state in
                v.stateLabel.rx.text.onNext(state)
                v.contentView.addSubview(v.stateLabel)
                v.makeStateLabelConstraints()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
    }
    
    private func addSubComponents() {
        addContentViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeRightArrowIconConstraints()
    }
}

/// Default ui setting method
extension SettingListCell {
    private func addContentViewSubComponents() {
        [titleLabel, rightArrowIcon].forEach { contentView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeRightArrowIconConstraints() {
        rightArrowIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(SettingListCellNameSpace.rightArrowIconImageTrailingInset)
            $0.width.equalTo(SettingListCellNameSpace.rightArrowIconWidth)
            $0.height.equalTo(rightArrowIcon.snp.width)
        }
    }
    
    private func makeStateLabelConstraints() {
        stateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(rightArrowIcon.snp.leading).offset(SettingListCellNameSpace.stateLabelTrailingOffset)
        }
    }
}

#if DEBUG

import SwiftUI

struct SettingListCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingListCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 56,
                   alignment: .center)
    }
    
    struct SettingListCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = SettingListCell()
            v.model.accept(.init(type: .lcokTheScreen, state: "꺼짐"))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

