//
//  MyPageNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit
import SnapKit

final class MyPageNavigationBar: UIView {
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = MyPageNavigationBarNameSpace.titleLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: MyPageNavigationBarNameSpace.titleLAbelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var pushConfigurationSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: MyPageNavigationBarNameSpace.pushConfigurationSettingsButtonIamge ),
                        for: .normal)
        button.backgroundColor = .clear
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: MyPageNavigationBarNameSpace.separatorBackgroundColorRed,
                                       green: MyPageNavigationBarNameSpace.separatorBackgroundColorGreen,
                                       blue: MyPageNavigationBarNameSpace.separatorBackgroundColorBlue,
                                       alpha: MyPageNavigationBarNameSpace.separatorBackgroundColorAlpha)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeTitleLabelConstraints()
        makeConfigurationSettingsButtonConstraints()
        makeSeparatorConstraints()
    }
}

extension MyPageNavigationBar {
    private func addViewSubComponents() {
        [titleLable, pushConfigurationSettingsButton, separator].forEach { addSubview($0) }
    }
    
    private func makeTitleLabelConstraints() {
        titleLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeConfigurationSettingsButtonConstraints() {
        pushConfigurationSettingsButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(CommonConstraintNameSpace.buttonWidth)
            $0.height.equalTo(CommonConstraintNameSpace.buttonHeight)
        }
    }
    
    private func makeSeparatorConstraints() {
        separator.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(MyPageNavigationBarNameSpace.separatorTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct MyPageNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        MyPageNavigationBar_Presentable()
    }
    
    struct MyPageNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyPageNavigationBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
