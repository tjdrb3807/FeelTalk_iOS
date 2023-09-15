//
//  ConfigurationSettingsTableViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ConfigurationSettingsTableViewCell: UITableViewCell {
    let model = PublishRelay<ConfigurationSettingsModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "화면잠금"
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_right_arrow"),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.text = "켜짐"
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, model in
                v.titleLabel.rx.text.onNext(model.title)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        contentView.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeTitleLabelConstraints()
    }
}

extension ConfigurationSettingsTableViewCell {
    private func addViewSubComponents() {
        [titleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
}

extension ConfigurationSettingsTableViewCell {
    func setData(with model: ConfigurationSettingsModel) {
        titleLabel.rx.text.onNext(model.title)
    }
}



#if DEBUG

import SwiftUI

struct ConfigurationSettingsTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationSettingsTableViewCell_Presentable()
    }
    
    struct ConfigurationSettingsTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ConfigurationSettingsTableViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
