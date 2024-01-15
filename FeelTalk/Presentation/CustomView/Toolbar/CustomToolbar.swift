//
//  CustomToolbar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import UIKit
import SnapKit

final class CustomToolbar: UIToolbar {
    var type: CustomToolbarType
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        
        switch type {
        case .ongoing:
            button.setTitle(CustomToolbarNameSpace.rightButtonOngoingTypeText, for: .normal)
        case .completion:
            button.setTitle(CustomToolbarNameSpace.rightButtonCompletionTypeText, for: .normal)
        }
        
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: CustomToolbarNameSpace.tightButtonTitleTextSize)
        button.setTitleColor(UIColor(named: CommonColorNameSpace.main500), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    init(type: CustomToolbarType) {
        self.type = type
        super.init(frame: (CGRect(origin: .zero,
                                  size: CGSize(width: UIScreen.main.bounds.width,
                                               height: CustomToolbarNameSpace.height))))
        
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        barTintColor = .white
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let barButtonItme = UIBarButtonItem(customView: rightButton)
        items = [space, barButtonItme]
    }
    
    private func addSubComponents() {
        addSubview(separator)
    }
    
    private func setConstraints() {
        separator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(separator.snp.top).offset(CustomToolbarNameSpace.separatorHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        CustomToolbar_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 55,
                   alignment: .center)
    }
    
    struct CustomToolbar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomToolbar(type: .ongoing)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
