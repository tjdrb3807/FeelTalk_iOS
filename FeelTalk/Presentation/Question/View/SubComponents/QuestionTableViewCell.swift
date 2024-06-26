//
//  QuestionTableViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionTableViewCell: UITableViewCell {
    let model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.montserratBold,
                            size: QuestionTableViewCellNameSpace.indexLabelTextSize)
        label.backgroundColor = UIColor(named: QuestionTableViewCellNameSpace.indexLabelBackgroundColor)
        label.layer.cornerRadius = QuestionTableViewCellNameSpace.indexLabelCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var questionBodyLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: QuestionTableViewCellNameSpace.questionBodyLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: QuestionTableViewCellNameSpace.topEdegeInset,
                                                                     left: QuestionTableViewCellNameSpace.leftEdegeInset,
                                                                     bottom: QuestionTableViewCellNameSpace.bottomEdegeInset,
                                                                     right: QuestionTableViewCellNameSpace.rightEdegeInset))
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: QuestionTableViewCellNameSpace.backgroundColor)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = QuestionTableViewCellNameSpace.cornerRadius
        contentView.clipsToBounds = true
        setUpData()
    }
    
    private func addSubComponents() {
        [indexLabel, questionBodyLable].forEach { contentView.addSubview($0) }
    }
    
    private func setConfigurations() {
        makeIndexLabelConstraints()
        makeQuestionBodyLabelConstraints()
    }
}

extension QuestionTableViewCell {
    private func makeIndexLabelConstraints() {
        indexLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(QuestionTableViewCellNameSpace.indexLabelLeadingInset)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.height.equalTo(QuestionTableViewCellNameSpace.indexLabelHeight)
        }
    }
    
    private func makeQuestionBodyLabelConstraints() {
        questionBodyLable.snp.makeConstraints {
            $0.leading.equalTo(indexLabel.snp.trailing).offset(QuestionTableViewCellNameSpace.questionBodyLabelLeadingOffset)
            $0.centerY.equalTo(indexLabel)
        }
    }
}

extension QuestionTableViewCell {
    private func setUpData() {
        self.model
            .withUnretained(self)
            .bind { c, question in
                c.indexLabel.rx.text.onNext(String(question.index + 1))
                c.questionBodyLable.rx.text.onNext(question.body)
            }.disposed(by: disposeBag)
    }
}

#if DEBUG

import SwiftUI

struct QuestionTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTableViewCell_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: QuestionTableViewCellNameSpace.hegith + QuestionTableViewCellNameSpace.bottomEdegeInset,
                   alignment: .center)
    }
    
    struct QuestionTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = QuestionTableViewCell()
            v.model.accept(.init(index: 0,
                                 pageNo: 0,
                                 title: "Test",
                                 header: "난 이게 가장 좋더라!",
                                 body: "당신이 가장 좋아하는 스킨십은?",
                                 highlight: [0],
                                 isMyAnswer: true,
                                 isPartnerAnswer: true,
                                 createAt: ""))
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
