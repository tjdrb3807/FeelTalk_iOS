//
//  QuestionTableView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit
import SnapKit

final class QuestionTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        self.setAttributes()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: QuestionTableViewCellNameSpace.backgroundColor)
        tableHeaderView = QuestionTableHeaderView(frame: CGRect(x: 0.0,
                                                                y: 0.0,
                                                                width: UIScreen.main.bounds.width,
                                                                height: QuestionTableHeaderViewNameSpace.height))
        register(QuestionTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: QuestionTableSectionHeaderViewNameSpace.identifier)
        register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCellNameSpace.identifier)
        rowHeight = QuestionTableViewCellNameSpace.hegith
        separatorStyle = .none
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self
    }
    
    private func setConfigurations() {
        
    }
}

// TODO: RxSwift로 변경
extension QuestionTableView: UITableViewDataSource {
    // TableView Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0, let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuestionTableSectionHeaderViewNameSpace.identifier) as? QuestionTableSectionHeaderView else { return nil }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? QuestionTableSectionHeaderViewNameSpace.height : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCellNameSpace.identifier, for: indexPath) as? QuestionTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

extension QuestionTableView: UITableViewDelegate {

}

#if DEBUG

import SwiftUI

struct QuestionTableView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTableView_Presentable()
    }
    
    struct QuestionTableView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionTableView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
