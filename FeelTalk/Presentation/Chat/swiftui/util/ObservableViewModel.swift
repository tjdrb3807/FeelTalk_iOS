//
//  ObservableViewModel.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard
import Combine

// https://github.com/holixfactory/RxSwift-MVVM-SwiftUI-SampleApp/tree/master
final class ObservableViewModel<ViewModelInputs, ViewModelOutputs>: ObservableObject {
    let inputs: ViewModelInputs
    let outputs: ObservableOutputs<ViewModelOutputs>
    private var cancellables = Set<AnyCancellable>()
  
    init(inputs: ViewModelInputs, outputs: ViewModelOutputs) {
        self.inputs = inputs
        self.outputs = .init(outputs)
        self.outputs.objectWillChange
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
    }
}

extension ObservableViewModel {
    
    @dynamicMemberLookup
    final class ObservableOutputs<ViewModelOutputs>: NSObject, ObservableObject {
        private let outputs: ViewModelOutputs
            
        init(_ outputs: ViewModelOutputs) {
            self.outputs = outputs
            super.init()
        }

        @Published private var values: [AnyHashable: Any] = [:]
        private let disposeBag = DisposeBag()

        subscript<O: ObservableConvertibleType>(
          dynamicMember keyPath: KeyPath<ViewModelOutputs, O>
        ) -> O.Element {
            guard let value = values[keyPath] as? O.Element else {
                fatalError("Value must be initialized")
            }
            return value
        }

        func bind<O: ObservableConvertibleType>(
          _ keyPath: KeyPath<ViewModelOutputs, O>,
          value: O.Element? = nil
        ) {
            if let value = value {
                values[keyPath] = value
            }

            outputs[keyPath: keyPath]
                .asObservable()
                .map { $0 as Any }
                .bind(to: rx[dynamicMember: \.values[keyPath]])
//                .bind(to: rx[\.values[keyPath]])
                .disposed(by: disposeBag)
        }
    }
}

