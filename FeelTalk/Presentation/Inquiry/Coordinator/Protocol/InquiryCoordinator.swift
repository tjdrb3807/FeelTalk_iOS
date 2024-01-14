//
//  InquiryCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation

protocol InquiryCoordinator: Coordinator {
    var inquiryViewController: InquiryViewController { get set }
    
    func dismiss()
}
