//
//  UIViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let soucre = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        
        return ControlEvent(events: soucre)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let soucre = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: soucre)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
    }
}
