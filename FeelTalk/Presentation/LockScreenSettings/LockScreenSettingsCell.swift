//
//  LockScreenSettingsCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockScreenSettingsCell: UITableViewCell {
    let modelObserver = PublishRelay<SettingsModel>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "화면잠금"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        
        return label
    }()
    
    private lazy var switchButton: CustomSwitchButton = { CustomSwitchButton() }()
    
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
    
    private func bind (){
        switchButton.isState.accept(false)
        
    }
    
    private func setProperties() {
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addCellSubComponents()
    }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeSwitchButtonConstraints()
    }
}

extension LockScreenSettingsCell {
    private func addCellSubComponents() {
        [titleLabel, switchButton].forEach { contentView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeSwitchButtonConstraints() {
        switchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.width.equalTo(CustomSwitchButtonNameSpace.barViewWidth)
            $0.height.equalTo(CustomSwitchButtonNameSpace.barViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockScreenSettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenSettingsCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 56,
                   alignment: .center)
    }
    
    struct LockScreenSettingsCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = LockScreenSettingsCell()
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
