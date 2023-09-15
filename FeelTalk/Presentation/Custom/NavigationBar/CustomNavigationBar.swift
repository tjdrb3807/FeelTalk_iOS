//
//  CustomNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum CustomNavigationBarMode {
    case configurationSettings
    case lockingSetting
}

final class CustomNavigationBar: UIView {
    var mode: CustomNavigationBarMode
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        switch mode {
        case .configurationSettings:
            button.setImage(UIImage(named: "icon_x_mark_black"),
                            for: .normal)
        case .lockingSetting:
            button.setImage(UIImage(named: "icon_left_arrow_black"),
                            for: .normal)
        }
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        switch mode {
        case .configurationSettings:
            label.text = "환경설정"
        case .lockingSetting:
            label.text = "화면잠금"
        }
        
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 18.0)
        label.backgroundColor = .clear
        
        return label
    }()
    
    init(mode: CustomNavigationBarMode) {
        self.mode = mode
        super.init(frame: .zero)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConfigurations() {
        makeLeftButtonConstraints()
        makeTitleLabelConstraints()
    }
}

extension CustomNavigationBar {
    private func addViewSubComponents() {
        [leftButton, titleLabel].forEach { addSubview($0) }
    }
    
    private func makeLeftButtonConstraints() {
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(CommonConstraintNameSpace.buttonWidth)
            $0.height.equalTo(CommonConstraintNameSpace.buttonHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar_Presentable()
    }
    
    struct CustomNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomNavigationBar(mode: .configurationSettings)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
