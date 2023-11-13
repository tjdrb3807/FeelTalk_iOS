//
//  HomeTodayQuesetionCountView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeTodayQuestionCountView: UIStackView {
    let count = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = HomeTodayQuestionCountViewNameSpace.descriptionLabelText
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: HomeTodayQuestionCountViewNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: HomeTodayQuestionCountViewNameSpace.descriptionLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardBold,
                            size: HomeTodayQuestionCountViewNameSpace.countLabelTextSize)
        label.setLineHeight(height: HomeTodayQuestionCountViewNameSpace.countLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var countDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = HomeTodayQuestionCountViewNameSpace.countDescriptionLabelText
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: HomeTodayQuestionCountViewNameSpace.countDescriptionLabelTextSize)
        label.setLineHeight(height: HomeTodayQuestionCountViewNameSpace.countDescriptionLabelLineHeight)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        count
            .map { String($0) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
//        backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addHomeTodayQuestionCountViewSubComponents()
        addCountStackViewSubComponents()
    }
}
 
extension HomeTodayQuestionCountView {
    private func addHomeTodayQuestionCountViewSubComponents() {
        [descriptionLabel, countStackView].forEach { addArrangedSubview($0) }
    }
    
    private func addCountStackViewSubComponents() {
        [countLabel, countDescriptionLabel].forEach { countStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct HomeTodayQuestionCountView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTodayQuestionCountView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - ((CommonConstraintNameSpace.leadingInset) + (CommonConstraintNameSpace.trailingInset)),
                   height: HomeTodayQuestionCountViewNameSpace.height,
                   alignment: .center)
    }
    
    struct HomeTodayQuestionCountView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = HomeTodayQuestionCountView()
            v.count.accept(100)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
