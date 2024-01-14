//
//  SignalViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class SignalViewController: UIViewController {
    var viewModel: SignalViewModel!
    private let dismiss = PublishSubject<Void>()
    private let selectedSignal = PublishRelay<Signal>()
    private let disposeBag = DisposeBag()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SignalViewNameSpace.bottomSheetViewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var panGestureArea: UIView = { UIView() }()
    
    private lazy var garbber: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray400)
        view.layer.cornerRadius = SignalViewNameSpace.garbberCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = SignalViewNameSpace.descriptionLabelText
        label.textColor = .black
        label.numberOfLines = SignalViewNameSpace.descriptionLabelNumberOfLines
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: SignalViewNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: SignalViewNameSpace.descriptionLabelLineHeight)
        
        return label
    }()
    
    fileprivate lazy var percentageView: SignalPercentageView = { SignalPercentageView() }()
    
    fileprivate lazy var dialView: SignalDialView = { SignalDialView() }()
    
    private lazy var changeSignalButton: UIButton = {
        let button = UIButton()
        button.setTitle(SignalViewNameSpace.changeSignalButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: SignalViewNameSpace.changeSignalButtonTitleTextSize)
        button.backgroundColor = .black
        button.layer.cornerRadius = SignalViewNameSpace.changeSignalButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.show()
    }
    
    private func bind() {
        Observable
            .merge(
                self.view.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                    guard let self = self else { return }
                    gestureRecognizer.delegate = self
                    delegate.simultaneousRecognitionPolicy = .never
                }).asObservable(),
                bottomSheetView.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                    guard let self = self else { return }
                    gestureRecognizer.delegate = self
                    delegate.simultaneousRecognitionPolicy = .never
                }).asObservable()
            ).when(.recognized)
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
                vc.dismiss.onNext(())
            }.disposed(by: disposeBag)
        
        panGestureArea.rx.panGesture()
            .withUnretained(self)
            .bind { vc, gesture in
                let transition = gesture.translation(in: vc.panGestureArea)

                guard transition.y > 0 else { return }

                switch gesture.state {
                case .changed:
                    vc.bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(SignalViewNameSpace.bottomSheetViewTopInset + transition.y) }
                case .ended:
                    if (transition.y < vc.bottomSheetView.bounds.height / 4) {
                        vc.bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(SignalViewNameSpace.bottomSheetViewTopInset) }
                        UIView.animate(withDuration: SignalViewNameSpace.bottomSheetAnimateDuration,
                                       delay: SignalViewNameSpace.bottomSheetAnimageDelay,
                                       options: .curveEaseInOut,
                                       animations: { vc.view.layoutIfNeeded() },
                                       completion: nil)
                    } else {
                        vc.hide()
                        vc.dismiss.onNext(())
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
        
        dialView.rx.panGesture()
            .skip(1)
            .withUnretained(self)
            .map { vc, gesture in gesture.location(in: vc.view) }
            .map { location -> Double in
                let center: CGPoint = .init(x: UIScreen.main.bounds.width / 2,
                                            y: CommonConstraintNameSpace.verticalRatioCalculator * 73.64)
                var degree = -atan2(location.y - center.y,
                                   location.x - center.x) * 180.0 / Double.pi

                if degree < 0.0 { degree = 360.0 + degree }

                return degree
            }.map { degree -> SignalType in
                switch degree {
                case 10.0..<62.0: return .love
                case 62.0..<117.0: return .ambiguous
                case 117..<170.0: return .refuse
                case 170.0..<270.0: return .tired
                case 270.0..<360.0: return .sexy
                case 0.0..<10.0: return .sexy
                default: return .sexy
                }
            }.distinctUntilChanged()
            .map { Signal(type: $0) }
            .bind(to: selectedSignal)
            .disposed(by: disposeBag)
        
        Observable<Signal>
            .merge(
                dialView.tiredPointButton.rx.tap.asObservable().map { Signal(type: .tired) },
                dialView.refusePointButton.rx.tap.asObservable().map { Signal(type: .refuse) },
                dialView.ambiguousPointButton.rx.tap.asObservable().map { Signal(type: .ambiguous) },
                dialView.lovePointButton.rx.tap.asObservable().map { Signal(type: .love) },
                dialView.sexyPointButton.rx.tap.asObservable().map { Signal(type: .sexy) }
            ).bind(to: selectedSignal)
            .disposed(by: disposeBag)
        
        changeSignalButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
            }.disposed(by: disposeBag)
    }
    
    private func bind(to viewModel: SignalViewModel) {
        let input = SignalViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            selectedSignal: self.selectedSignal.asObservable(),
            tapChangeSignalButton: changeSignalButton.rx.tap,
            dismiss: self.dismiss)
        
        let output = viewModel.transfer(input: input)
        
        output.selectedSignal
            .bind(to: dialView.model)
            .disposed(by: disposeBag)
        
        output.selectedSignal
            .bind(to: percentageView.model)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .black.withAlphaComponent(SignalViewNameSpace.backgrouneColorAlpha)
        UIGestureRecognizer().delegate = self
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetViewConstraints()
    }
    
    private func setConstraints() {
        makeBottomSheetViewConstraints()
        makePanGestureAreaConstratins()
        makeGarbberConstraints()
        makeDescriptionLabelConstraints()
        makePercentageViewConstraints()
        makeDialViewConstraints()
        makeChangeSignalButtonConstraints()
    }
}

extension SignalViewController {
    private func addViewSubComponents() { view.addSubview(bottomSheetView) }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomSheetViewConstraints() {
        [panGestureArea, garbber, descriptionLabel, percentageView, dialView, changeSignalButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    private func makePanGestureAreaConstratins() {
        panGestureArea.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(percentageView.snp.bottom)
        }
    }
    
    private func makeGarbberConstraints() {
        garbber.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(SignalViewNameSpace.garbberTopInset)
            $0.width.equalTo(SignalViewNameSpace.garbberWidth)
            $0.height.equalTo(SignalViewNameSpace.garbberHeight)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalViewNameSpace.descriptionLabelTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makePercentageViewConstraints() {
        percentageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalPercentageViewNameSpace.topInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeDialViewConstraints() {
        dialView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalDialViweNameSpace.topInset)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(SignalDialViweNameSpace.height)
        }
    }
    
    private func makeChangeSignalButtonConstraints() {
        changeSignalButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SignalViewNameSpace.changeSignalButtonTopInset)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.height.equalTo(SignalViewNameSpace.changeSignalButtonHeight)
        }
    }
}

extension SignalViewController {
    private func show(completion: @escaping () -> Void = {}) {
        bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(SignalViewNameSpace.bottomSheetViewTopInset) }
        
        UIView.animate(
            withDuration: SignalViewNameSpace.bottomSheetAnimateDuration,
            delay: SignalViewNameSpace.bottomSheetAnimageDelay,
            options: .curveEaseInOut,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
    
    
    private func hide(completion: @escaping () -> Void = {} ) {
        bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(UIScreen.main.bounds.height) }
        
        UIView.animate(
            withDuration: SignalViewNameSpace.bottomSheetAnimateDuration,
            delay: SignalViewNameSpace.bottomSheetAnimageDelay,
            options: .curveEaseInOut,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}

extension SignalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.bottomSheetView) == false else { return false }

        return true
    }
}

#if DEBUG

import SwiftUI

struct SignalViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignalViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct SignalViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = SignalViewController()
            let vm = SignalViewModel(coordinator: DefaultSignalCoordinator(UINavigationController()),
                                     signalUseCase: DefaultSignalUseCase(signalRepositroy: DefaultSignalRepository()))
            
            vc.viewModel = vm
            vc.percentageView.model.accept(Signal(type: .ambiguous))
            vc.dialView.model.accept(Signal(type: .refuse))
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
