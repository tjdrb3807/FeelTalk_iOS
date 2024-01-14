//
//  QuestionTableView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class QuestionTableView: UITableView {
    lazy var questionTableHeader: QuestionTableHeaderView = {
        QuestionTableHeaderView(frame: CGRect(x: QuestionTableHeaderViewNameSpace.x,
                                              y: QuestionTableHeaderViewNameSpace.y,
                                              width: UIScreen.main.bounds.width,
                                              height: QuestionTableHeaderViewNameSpace.height))
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        self.setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = UIColor(named: QuestionTableViewCellNameSpace.backgroundColor)
        tableHeaderView = questionTableHeader
        register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCellNameSpace.identifier)
        rowHeight = QuestionTableViewCellNameSpace.hegith
        separatorStyle = .none
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
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
