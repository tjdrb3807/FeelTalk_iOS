//
//  QuestionViewBottomSectionList.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionViewBottomSectionList: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
//        rowHeight = UITableView.automaticDimension
//        estimatedRowHeight = UITableView.automaticDimension
        separatorStyle = .none
        showsVerticalScrollIndicator = true
        
        register(QuestionListCell.self, forCellReuseIdentifier: "QuestionListCell")
        
        delegate = self
        dataSource = self
    }
}

extension QuestionViewBottomSectionList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell", for: indexPath) as? QuestionListCell else { return UITableViewCell() }
        
        return cell
    }
}

extension QuestionViewBottomSectionList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewBottomSectionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewBottomSectionList_Presentable()
    }
    
    struct QuestionViewBottomSectionList_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionViewBottomSectionList()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
