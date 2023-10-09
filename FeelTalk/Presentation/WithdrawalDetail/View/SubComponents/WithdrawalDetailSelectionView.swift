//
//  WithdrawalDetailSelectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WithdrawalDetailSelectionView: UIStackView {
    let cellData = PublishSubject<[WithdrawalReasonType]>()
    private let disposeBag = DisposeBag()
    
    private lazy var titleView: CustomTitleView = { CustomTitleView(type: .withdrawalReason) }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.isScrollEnabled = false
        tableView.rowHeight = 70
        tableView.register(DefaultWithdrawalReasonCell.self, forCellReuseIdentifier: "DefaultWithdrawalReasonCell")
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind() {
        cellData.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tv, row, item in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "DefaultWithdrawalReasonCell", for: index) as! DefaultWithdrawalReasonCell
                cell.type.accept(item)
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = 8
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleViewConstraints()
        makeTableViewConstraints()
    }
}

extension WithdrawalDetailSelectionView {
    private func addViewSubComponents() { [titleView, tableView].forEach { addArrangedSubview($0) } }
    
    private func makeTitleViewConstraints() {
        titleView.snp.makeConstraints { $0.height.equalTo(CustomTitleViewNameSpace.height) }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
    }
}


#if DEBUG

import SwiftUI

struct WithdrawalDetailSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetailSelectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 600,
                   alignment: .center)
    }
    
    struct WithdrawalDetailSelectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = WithdrawalDetailSelectionView()
            view.cellData.onNext([.breakUp, .noFunctionality, .bugOrError, .etc])
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
