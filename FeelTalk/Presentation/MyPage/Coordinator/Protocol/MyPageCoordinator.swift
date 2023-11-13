//
//  MyPageCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import Foundation

protocol MyPageCoordinator: Coordinator {
    var myPageViewController: MyPageViewController { get set }
    
    func showChatFlow()
    
    func showPartnerInfoFlow()
    
    func showSettingListFlow()
    
    func showInquiryFlow()
    
    func showSuggestionsFlow()
}
