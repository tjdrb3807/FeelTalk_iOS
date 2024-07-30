//
//  WithdrawalReasonsSelectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class WithdrawalReasonsSelectionView: UIStackView {
    let modelList = PublishRelay<[WithdrawalReasonsType]>()
    let cellTapObserver = PublishRelay<WithdrawalReasonsType>()
    let selectedCell = PublishRelay<WithdrawalReasonsType>()
    let etcReason = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = WithdrawalReasonsSelectionViewNameSpace.contentStackViewSpacing

        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = WithdrawalReasonsSelectionViewNameSpace.headerStackViewSpacing
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = WithdrawalReasonsSelectionViewNameSpace.headerLabelText
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: WithdrawalReasonsSelectionViewNameSpace.headerLabelTextSize)
        label.setLineHeight(height: WithdrawalReasonsSelectionViewNameSpace.headerLabelLineHeight)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var asteriskIcon: UIImageView = { UIImageView(image: UIImage(named: WithdrawalReasonsSelectionViewNameSpace.asteriskIconImage)) }()
    
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = WithdrawalReasonsSelectionViewNameSpace.cellStackViewSpacing
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        modelList
            .withUnretained(self)
            .bind { v, event in
                event.forEach { model in
                    let cell = WithdrawalReasonCell()
                    cell.type.accept(model)
                    cell.rx.tapGesture()
                        .when(.recognized)
                        .asObservable()
                        .map { _ in model }
                        .bind { model in
                            v.selectedCell.accept(model)
                            v.cellTapObserver.accept(model)
                        }.disposed(by: v.disposeBag)
                    v.cellStackView.addArrangedSubview(cell)
                    
                    cell.etcReason
                        .bind(to: v.etcReason)
                        .disposed(by: v.disposeBag)
                    
                    if model == .etc {
                        cell.snp.makeConstraints { $0.bottom.equalTo(cell.snp.top).offset(WithdrawalReasonCellNameSpace.defaultHeight) }
                    } else {
                        cell.snp.makeConstraints { $0.height.equalTo(WithdrawalReasonCellNameSpace.defaultHeight) }
                    }
                }
            }.disposed(by: disposeBag)
        
        selectedCell
            .asObservable()
            .withUnretained(self)
            .bind { v, type in
                v.cellStackView.arrangedSubviews.forEach { cell in
                    guard let cell = cell as? WithdrawalReasonCell else { return }
                    
                    type == cell.type.value ?
                    cell.isSelected.accept(true) :
                    cell.isSelected.accept(false)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = WithdrawalReasonsSelectionViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
        addHeaderStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTopSpacingConstraints()
        makeHeaderStackViewConstraints()
        makeCellStackViewConstraints()
    }
}

extension WithdrawalReasonsSelectionView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [topSpacing, headerStackView, cellStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeTopSpacingConstraints() {
        topSpacing.snp.makeConstraints { $0.height.equalTo(WithdrawalReasonsSelectionViewNameSpace.topSpacingHeight) }
    }
    
    private func makeHeaderStackViewConstraints() {
        headerStackView.snp.makeConstraints { $0.height.equalTo(WithdrawalReasonsSelectionViewNameSpace.headerStackViewHeight)}
    }
    
    private func makeCellStackViewConstraints() {
        cellStackView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    private func addHeaderStackViewSubComponents() {
        [headerLabel, asteriskIcon].forEach { headerStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct WithdrawalReasonsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalReasonsSelectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: WithdrawalReasonsSelectionViewNameSpace.height,
                   alignment: .center)
    }
    
    struct WithdrawalReasonsSelectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = WithdrawalReasonsSelectionView()
            v.modelList.accept([.breakUp, .noFunction, .bugOrError, .etc])
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
