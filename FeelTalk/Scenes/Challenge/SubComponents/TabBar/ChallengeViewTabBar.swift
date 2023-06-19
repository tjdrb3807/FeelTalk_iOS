//
//  ChallengeViewTabBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ChallengeTabItem: Int, CaseIterable, Equatable {
    typealias TabItemButtonColorSet = (titleColor: UIColor?, countColor: UIColor?, stateBarColor: UIColor?)
    
    case want
    case done
    
    var titleText: String {
        switch self {
        case .want:
            return "하고싶어요"
        case .done:
            return "이뤘어요"
        }
    }
    
    var normalColor: TabItemButtonColorSet {
        switch self {
        case .want:
            return (UIColor(named: "gray_600"), UIColor(named: "main_400"), UIColor(named: "main_400"))
        case .done:
            return (UIColor(named: "gray_600"), UIColor(named: "gray_400"), UIColor(named: "gray_400"))
        }
    }
    
    var selectedColor: TabItemButtonColorSet {
        switch self {
        case .want:
            return (UIColor.black, UIColor(named: "main_500"), UIColor(named: "main_500"))
        case .done:
            return (UIColor.black, UIColor.black, UIColor.black)
        }
    }
}

final class ChallengeViewTabBar: UIView {
    private var buttons = [ChallengeViewTabBarButton]()
    let items = ChallengeTabItem.allCases
    fileprivate var selectedIndex = 0 {
        didSet {
            buttons
                .enumerated()
                .forEach { index, button in
                    button.isSelected = index == selectedIndex
                    
                    let isButtonSelected = selectedIndex == index
                    
                    guard let titleColor = isButtonSelected ? button.tabBarItemType.selectedColor.titleColor : button.tabBarItemType.normalColor.titleColor else { return }
                    guard let countColor = isButtonSelected ? button.tabBarItemType.selectedColor.countColor : button.tabBarItemType.normalColor.countColor  else { return }
                    guard let stateBarColor = isButtonSelected ? button.tabBarItemType.selectedColor.stateBarColor : button.tabBarItemType.normalColor.stateBarColor else { return }
                    
                    button.setTitleColor(titleColor)
                    button.setCountColor(countColor)
                    button.setStateColor(stateBarColor)
                }
        }
    }
    
    private let disposeBag = DisposeBag()
    fileprivate var tapSubject = PublishSubject<Int>()
    
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setButtons()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtons() {
        items
            .enumerated()
            .forEach { index, item in
                let button = ChallengeViewTabBarButton(tabBarItemType: item)
                
                button.isSelected = index == 0
                
                let isButtonSelected = selectedIndex == index
                
                guard let titleColor = isButtonSelected ? button.tabBarItemType.selectedColor.titleColor : button.tabBarItemType.normalColor.titleColor else { return }
                guard let countColor = isButtonSelected ? button.tabBarItemType.selectedColor.countColor : button.tabBarItemType.normalColor.countColor  else { return }
                guard let stateBarColor = isButtonSelected ? button.tabBarItemType.selectedColor.stateBarColor : button.tabBarItemType.normalColor.stateBarColor else { return }
                
                button.setTitleColor(titleColor)
                button.setCountColor(countColor)
                button.setStateColor(stateBarColor)

                
                button.rx.tap
                    .map { _ in index }
                    .bind(to: tapSubject)
                    .disposed(by: disposeBag)
                
                buttons.append(button)
            }
        
        tapSubject
            .bind(to: rx.selectedIndex)
            .disposed(by: disposeBag)
    }
    
    private func setConfig() {
        buttons.forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension Reactive where Base: ChallengeViewTabBar {
    var tapButton: Observable<Int> {
        base.tapSubject
    }
    
    var changeIndex: Binder<Int> {
        Binder(base) { base, index in
            base.selectedIndex = index
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewTabBar_Presentable()
    }
    
    struct ChallengeViewTabBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeViewTabBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
