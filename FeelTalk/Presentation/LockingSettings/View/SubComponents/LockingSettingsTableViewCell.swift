//
//  LockingSettingsTableViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingSettingsTableViewCell: UITableViewCell {
    let model = PublishRelay<LockingSettingsModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var switchButton: CustomSwitchButton = { CustomSwitchButton() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.setAttributes()
        self.addCellSubComponents()
        self.makeTitleLabelConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { c, model in
                c.setTitleLabelText(with: model.type)
                c.updateCellSubComponents(with: model.type)
                c.makeSwitchButtonConstratins(with: model.type)
                
                if model.type == .lockTheScreen { c.switchButton.isState.accept(model.state!) }
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Default UI setting method.
extension LockingSettingsTableViewCell {
    private func addCellSubComponents() { contentView.addSubview(titleLabel) }
    
    private func makeTitleLabelConstratins() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
}

// MARK: Update UI setting methdo.
extension LockingSettingsTableViewCell {
    private func setTitleLabelText(with type: LockingSettingsViewCellType) {
        switch type {
        case .lockTheScreen:
            titleLabel.rx.text.onNext("화면잠금")
        case .changePassword:
            titleLabel.rx.text.onNext("암호변경")
        }
    }
    
    private func updateCellSubComponents(with type: LockingSettingsViewCellType) {
        switch type {
        case .lockTheScreen:
            contentView.addSubview(switchButton)
        case .changePassword:
            break
        }
    }
    
    private func makeSwitchButtonConstratins(with type: LockingSettingsViewCellType) {
        switch type {
        case .lockTheScreen:
            switchButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
                $0.width.equalTo(CustomSwitchButtonNameSpace.barViewWidth)
                $0.height.equalTo(CustomSwitchButtonNameSpace.barViewHeight)
            }
        case .changePassword:
            break
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingSettingsTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        LockingSettingsTableViewCell_Presentable()
    }
    
    struct LockingSettingsTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let cell = LockingSettingsTableViewCell()
            cell.model.accept(LockingSettingsModel(type: .lockTheScreen, state: false))
            
//            cell.model.accept(LockingSettingsModel(type: .changePassword))
            
            return cell
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
