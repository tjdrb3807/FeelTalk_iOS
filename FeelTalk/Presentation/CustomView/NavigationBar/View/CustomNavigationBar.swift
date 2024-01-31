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

final class CustomNavigationBar: UIView {
    lazy var leftButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: CustomNavigationBarNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    init(type: CustomNavigationBarType, isRootView: Bool) {
        super.init(frame: .zero)
        titleLabel.rx.text.onNext(type.rawValue)
        
        isRootView ?
        leftButton.setImage(UIImage(named: CustomNavigationBarNameSpace.leftButtonXMarkImage), for: .normal) :
        leftButton.setImage(UIImage(named: CustomNavigationBarNameSpace.leftButtonLeftArrowImage), for: .normal)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() { backgroundColor = .clear }
    
    private func addSubComponents() { addViewSubComponents() }
    
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
    
    private func makeTitleLabelConstraints() { titleLabel.snp.makeConstraints { $0.center.equalToSuperview() } }
}

extension CustomNavigationBar {
    public func makeNavigationBarConstraints() {
        self.snp.makeConstraints {
            $0.top.equalTo(superview!.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.top).offset(CustomNavigationBarNameSpace.height)
        }
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
            CustomNavigationBar(type: .lockingHintSettings, isRootView: true)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
