//
//  PartnerInfoCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

protocol PartnerInfoCoordinator: Coordinator {
    var partnerInfoViewController: PartnerInfoViewController { get set }
    
    func showBreakUpFlow()
}
