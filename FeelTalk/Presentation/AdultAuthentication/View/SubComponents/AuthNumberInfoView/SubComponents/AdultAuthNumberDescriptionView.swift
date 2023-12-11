//
//  AdultAuthNumberDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthNumberDesciptionView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = AdultAuthNumberDescriptionViewNameSpace.contentStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthNumberDescriptionViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthNumberDescriptionViewNameSpace.descriptionLabelTextSize)
        label.numberOfLines = AdultAuthNumberDescriptionViewNameSpace.descriptionLabelNumberOfLines
        label.backgroundColor = .clear
        label.setLineHeight(height: AdultAuthNumberDescriptionViewNameSpace.desctiptionLabelLineHeight)
        
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
    }
}

extension AdultAuthNumberDesciptionView {
    private func addViewSubComponents() { addSubview(contentStackView) }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(AdultAuthNumberDescriptionViewNameSpace.contentStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(AdultAuthNumberDescriptionViewNameSpace.contentStackViewTrailingInset)
        }
    }
    
    private func addContentStackViewSubComponents() { contentStackView.addArrangedSubview(descriptionLabel) }
}

#if DEBUG

import SwiftUI

struct AdultAuthNumberDesciptionView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthNumberDesciptionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 36.0,
                   alignment: .center)
    }
    
    struct AdultAuthNumberDesciptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthNumberDesciptionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
