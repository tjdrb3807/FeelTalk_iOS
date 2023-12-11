//
//  AdultAuthWarningView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import UIKit
import SnapKit

final class AdultAuthWarningView: UIView {
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthWarningViewNameSpace.warningLabelText
        label.textColor = .red
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthWarningViewNameSpace.warningLabelTextSize)
        label.setLineHeight(height: AdultAuthWarningViewNameSpace.warningLabelLineHeight)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setPropertie()
        self.addSubComponent()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPropertie() { backgroundColor = .clear }
    
    private func addSubComponent() { addSubview(warningLabel) }
    
    private func setConstraints() {
        warningLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(AdultAuthWarningViewNameSpace.warningLabelLeadingInset)
            $0.trailing.equalToSuperview().inset(AdultAuthWarningViewNameSpace.warningLabelTrailingInset)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthWarningView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthWarningView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthWarningViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthWarningView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthWarningView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
