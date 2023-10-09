//
//  SettingListViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingListViewModel {
    weak var coordinatro: SettingListCoordinator?
    private let configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    private let sectionModel = BehaviorRelay<[SettingListSectionModel]>(value: [SettingListSectionModel(header: "first", items: [SettingListModel(type: .lcokTheScreen)]),
                                                                                SettingListSectionModel(header: "second", items: [SettingListModel(type: .feelTalkInfo)])])
    private let isLock = PublishRelay<String>()
    
    struct Input{
        let viewWillAppear: ControlEvent<Bool>
    }
    
    struct Output {
        let sectionModel: BehaviorRelay<[SettingListSectionModel]>
    }
    
    init(coordinatro: SettingListCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinatro = coordinatro
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.configurationUseCase.getConfigurationInfo()
                    
                
            }.disposed(by: disposeBag)

        return Output(sectionModel: self.sectionModel)
    }
}

extension SettingListViewModel {
    private func switchString(to state: Bool) -> String {
        state ? "켜짐" : "꺼짐"
    }
}
