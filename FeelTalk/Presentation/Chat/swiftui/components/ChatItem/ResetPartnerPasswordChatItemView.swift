//
//  ResetPartnerPasswordChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import Foundation
import UIKit
import SwiftUI

struct ResetPartnerPasswordChatItemView: UIViewRepresentable {
    var onClickHelp: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        return LockNumberOpenGraph {
            onClickHelp()
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
