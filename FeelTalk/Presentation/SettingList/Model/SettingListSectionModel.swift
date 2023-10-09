//
//  SettingListSectionModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import Foundation
import RxDataSources

struct SettingListSectionModel {
    var header: String
    var items: [Item]
}

extension SettingListSectionModel: SectionModelType {
    typealias Item = SettingListModel
    
    init(original: SettingListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
