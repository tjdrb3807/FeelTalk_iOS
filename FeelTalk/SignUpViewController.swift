//
//  SignUpViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

#if DEBUG

import SwiftUI

struct SignUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignUpViewController_Presentable()
    }
    
    struct SignUpViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            SignUpViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
