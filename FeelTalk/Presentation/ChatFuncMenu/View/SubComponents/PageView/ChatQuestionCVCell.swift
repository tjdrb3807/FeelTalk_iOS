//
//  ChatQuestionCVCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct ChatQuestionSection {
    var items: [Item]
}

extension ChatQuestionSection: SectionModelType {
    typealias Item = ChatQuestionCellModel
    
    init(original: ChatQuestionSection, items: [ChatQuestionCellModel]) {
        self = original
        self.items = items
    }
}

final class ChatQuestionCVCell: UICollectionViewCell {
    let modelObserver = BehaviorRelay<[ChatQuestionSection]>(value: [])
    static let selectedItemObserver = BehaviorRelay<IndexPath?>(value: nil)
    private let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<ChatQuestionSection>(configureCell: { ds, tv, indexPath, item in
        guard let cell = tv.dequeueReusableCell(withIdentifier: ChatQuestionCellNameSpace.identifier) as? ChatQuestionCell else { return UITableViewCell() }
        cell.modelObserver.accept(item)
        
        return cell
    })
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.register(ChatQuestionCell.self, forCellReuseIdentifier: ChatQuestionCellNameSpace.identifier)
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: ChatQuestionCVCellNameSpace.tableViewHeaderHeight)))
        tableView.tableFooterView = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: ChatQuestionCVCellNameSpace.tableViewFooterHeight)))
        
        modelObserver
            .skip(1)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable
            .zip(
                tableView.rx.itemSelected,
                tableView.rx.modelSelected(ChatQuestionSection.Item.self)
            ).map { (indexPath: $0, question: $1.model) }
            .bind { event in
                ChatQuestionCVCell.selectedItemObserver.accept(event.indexPath)
                ChatFuncMenuViewModel.selectedQuestionModelObserver.accept(event.question)
            }.disposed(by: disposeBag)
       
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
    }
    
    private func addSubComponents() {
        contentView.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension ChatQuestionCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ChatQuestionCellNameSpace.height
    }
}

#if DEBUG

import SwiftUI

struct ChatQuestionCVCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatQuestionCVCell_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChatQuestionCVCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = ChatQuestionCVCell()
            c.modelObserver
                .accept([
                    ChatQuestionSection(
                        items: [
                            ChatQuestionCellModel(
                                model: Question(index: 10, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: true,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 9, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 8, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 7, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 6, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil,partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 5, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 4, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil,isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 3, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "우리의 스킨십 속도는 어떤 것 같아?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 2, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "연인이 준비해줬으면 하는 특별한 이벤트는?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false),
                            ChatQuestionCellModel(
                                model: Question(index: 1, pageNo: 0, title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?", header: "난 이게 가장 좋더라!", body: "당신이 가장 좋아하는 스킨십은?", highlight: [0], myAnser: nil, partnerAnser: nil, isMyAnswer: false, isPartnerAnswer: false, createAt: "2024-01-01T12:00:00"),
                                isTodayQuestion: false,
                                isSelected: false)
                        ])
                ])
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

