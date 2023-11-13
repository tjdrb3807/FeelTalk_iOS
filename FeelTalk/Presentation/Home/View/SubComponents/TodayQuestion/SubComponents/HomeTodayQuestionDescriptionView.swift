//
//  HomeTodayQuestionDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/20.
//

import UIKit
import SnapKit

final class HomeTodayQuestionDescriptionView: UIStackView {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = HomeTodayQuestionDescriptionViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.main100)
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: HomeTodayQuestionDescriptionViewNameSpace.descriptionLabelTextSize)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.main600)
        layer.cornerRadius = HomeTodayQuestionDescriptionViewNameSpace.cornerRadius
        clipsToBounds = true
        
        axis = .vertical
        alignment = .center
        distribution = .fill
    }
    
    private func addSubComponents() { addArrangedSubview(descriptionLabel) }
}

#if DEBUG

import SwiftUI

struct HomeTodayQuestionDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodayQuestionDescriptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: HomeTodayQuestionDescriptionViewNameSpace.width,
                   height: HomeTodayQuestionDescriptionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodayQuestionDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeTodayQuestionDescriptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
