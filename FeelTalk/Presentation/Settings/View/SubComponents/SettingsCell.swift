//
//  SettingsCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingsCell: UITableViewCell {
    let modelObserver = PublishRelay<SettingsModel>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SettingsCellNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SettingsCellNameSpace.stateLabelTextSize)
        
        return label
    }()
    
    private lazy var arrowIcon: UIImageView = { UIImageView(image: UIImage(named: "icon_arrow_right")) }()
    
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
    
    private func bind () {
        modelObserver
            .map { $0.category.rawValue }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        modelObserver
            .map { $0.isArrowIconHidden }
            .bind(to: arrowIcon.rx.isHidden)
            .disposed(by: disposeBag)
        
        modelObserver
            .withUnretained(self)
            .bind { c, model in
                guard let state = model.state else { return }

                c.stateLabel.rx.text.onNext(state)
                c.contentView.addSubview(c.stateLabel)
                c.stateLabel.snp.makeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.width.equalTo(c.stateLabel.intrinsicContentSize.width)
                }
                
                if model.isArrowIconHidden {
                    c.stateLabel.snp.makeConstraints {
                        $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
                    }
                } else {
                    c.stateLabel.snp.makeConstraints {
                        $0.trailing.equalTo(c.arrowIcon.snp.leading)
                    }
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }
    
    private func addSubComponents() { addCellSubComponents() }
    
    private func setConstraints() {
        makeTitleLabelConstraints()
        makeArrowIconConstraints()
    }
}

extension SettingsCell {
    private func addCellSubComponents() {
        [titleLabel, arrowIcon].forEach { contentView.addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeArrowIconConstraints() {
        arrowIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: SettingsCellNameSpace.height,
                   alignment: .center)
    }
    
    struct SettingsCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = SettingsCell()
            c.modelObserver.accept(SettingsModel(category: .lock,
                                                 state: Optional("켜짐"),
                                                 isArrowIconHidden: false))
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

