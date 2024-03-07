//
//  LockNumberHintPickerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockNubmerHintPickerView: UITableView {
    private let items = BehaviorRelay<[LockNumberHintType]>(value: LockNumberHintType.allCases)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        register(LockNumberHintPickerCell.self,
                 forCellReuseIdentifier: LockNumberHintPickerCellNameSpace.identifier)
        
        layer.borderWidth = LockNumberHintPickerViewNameSpace.borderWidth
        layer.borderColor = UIColor(named: CommonColorNameSpace.gray100)?.cgColor
        layer.cornerRadius = LockNumberHintPickerViewNameSpace.cornerRadius
        alwaysBounceVertical = false
        
        separatorStyle = .singleLine
        separatorColor = UIColor(named: CommonColorNameSpace.gray100)
        separatorInset = UIEdgeInsets(
            top: LockNumberHintPickerViewNameSpace.separatorTopInset,
            left: LockNumberHintPickerViewNameSpace.separatorLeftInset,
            bottom: LockNumberHintPickerViewNameSpace.separatorBottomInset,
            right: LockNumberHintPickerViewNameSpace.separatorRightInset)
        
        items
            .asDriver(onErrorJustReturn: [])
            .drive(rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(withIdentifier: LockNumberHintPickerCellNameSpace.identifier) as? LockNumberHintPickerCell else { return UITableViewCell() }
                cell.setUp(title: item.convertLabelText())
                cell.selectionStyle = .none
                
                return cell
            }.disposed(by: disposeBag)
        
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension LockNubmerHintPickerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        LockNumberHintPickerCellNameSpace.height
    }
}

#if DEBUG

import SwiftUI

struct LockNubmerHintPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LockNubmerHintPickerView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: LockNumberHintPickerViewNameSpace.height,
                   alignment: .center)
    }
    
    struct LockNubmerHintPickerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LockNubmerHintPickerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
