//
//  MyPageTableViewCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import RxSwift
import SnapKit
import RxSwift
import RxCocoa

final class MyPageTableViewCell: UITableViewCell {
    let cellType = PublishRelay<MyPageTableViewCellType>()
    private let disposeBag = DisposeBag()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: MyPageTableViewCellNameSpace.rightImageConfigurationSettingsTypeImage)
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = MyPageTableViewCellNameSpace.titleLabelConfigurationSettingsTypeText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: MyPageTableViewCellNameSpace.titleLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        cellType
            .withUnretained(self)
            .bind { v, type in
                v.updataRightImageView(with: type)
                v.updateTitleLabelText(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func addSubComponents() {
        addCellSubComponents()
    }
    
    private func setConstraints() {
        makeRightImageViewConstraints()
        makeTitleLabelConstraints()
    }
}

extension MyPageTableViewCell {
    private func addCellSubComponents() {
        [rightImageView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func makeRightImageViewConstraints() {
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(MyPageTableViewCellNameSpace.rightImageViewLeadingInset)
            $0.width.equalTo(CommonConstraintNameSpace.buttonWidth)
            $0.height.equalTo(CommonConstraintNameSpace.buttonHeight)
        }
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rightImageView.snp.trailing).offset(MyPageTableViewCellNameSpace.rightImageViewLeadingInset)
        }
    }
}

extension MyPageTableViewCell {
    private func updataRightImageView(with type: MyPageTableViewCellType) {
        switch type {
        case .configurationSettings:
            rightImageView.rx.image.onNext(UIImage(named: MyPageTableViewCellNameSpace.rightImageConfigurationSettingsTypeImage))
        case .inquiry:
            rightImageView.rx.image.onNext(UIImage(named: MyPageTableViewCellNameSpace.rightImageViewInquriyTypeImage))
        case .questionSuggestions:
            rightImageView.rx.image.onNext(UIImage(named: MyPageTableViewCellNameSpace.rightImageViewQuestionSuggestionsTypeImage))
        }
    }
    
    private func updateTitleLabelText(with type: MyPageTableViewCellType) {
        switch type {
        case .configurationSettings:
            titleLabel.rx.text.onNext(MyPageTableViewCellNameSpace.titleLabelConfigurationSettingsTypeText)
        case .inquiry:
            titleLabel.rx.text.onNext(MyPageTableViewCellNameSpace.titleLabelInquriyTypeText)
        case .questionSuggestions:
            titleLabel.rx.text.onNext(MyPageTableViewCellNameSpace.titleLabelQuestionSuggestionsTypeText)
        }
    }
}

#if DEBUG

import SwiftUI

struct MyPageTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPageTableViewCell_Presentable()
    }
    
    struct MyPageTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyPageTableViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
