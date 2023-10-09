//
//  SuggestionsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import Foundation

protocol SuggestionsCoordinator: Coordinator {
    var suggestionsViewController: SuggestionsViewController { get set }
    
    func dismiss()
}
