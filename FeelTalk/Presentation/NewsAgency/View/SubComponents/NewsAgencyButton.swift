//
//  NewsAgencyButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NewsAgencyButton: UIButton {
    let type: NewsAgencyType
    private let disposeBag = DisposeBag()
    
    lazy var newsAgencyLabel: UILabel = {
        let label = UILabel()
        
        switch type {
        case .skt:
            label.text = "SKT"
        case .kt:
            label.text = "KT"
        case .lg:
            label.text = "LG U+"
        case .sktThrifty:
            label.text = "SKT 알뜰폰"
        case .ktThrifty:
            label.text = "KT 알뜰폰"
        case .lgThrifty:
            label.text = "LG 알뜰폰"
        }
        
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: NewsAgencyButtonNameSpace.newsAgencyLabelTextSize)
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    init(type: NewsAgencyType) {
        self.type = type
        super.init(frame: .zero)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = .white
        layer.borderWidth = NewsAgencyButtonNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray300)?.cgColor
        layer.cornerRadius = NewsAgencyButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() { addSubview(newsAgencyLabel) }
    
    private func setConstraints() {
        newsAgencyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct NewsAgencyButton_Previews: PreviewProvider {
    static var previews: some View {
        NewsAgencyButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: NewsAgencyButtonNameSpace.height,
                   alignment: .center)
    }
    
    struct NewsAgencyButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            NewsAgencyButton(type: .skt)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}


#endif
