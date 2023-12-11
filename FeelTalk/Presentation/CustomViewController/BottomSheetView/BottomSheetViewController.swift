//
//  BottomSheetViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class BottomSheetViewController: UIViewController {
    /// bottomSheetView의 topInset 설정
    private var topInset: CGFloat = 0.0
    private let disposeBag = DisposeBag()
    
    /// VC dismiss Observable
    var dismiss = PublishRelay<Bool>()
    
    lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = BottomSheetViewControllerNameSpace.bottomSheetViewCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var garbber: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CommonColorNameSpace.gray300)
        view.layer.cornerRadius = BottomSheetViewControllerNameSpace.garbberCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.addSubComponents()
        self.setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        show()
    }
    
    private func bind() {
        Observable
            .merge(view.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                guard let self = self else { return }
                
                gestureRecognizer.delegate = self
                delegate.simultaneousRecognitionPolicy = .never
            }).asObservable(),
                   bottomSheetView.rx.tapGesture(configuration: { [weak self] gestureRecognizer, delegate in
                guard let self = self else { return }
                
                gestureRecognizer.delegate = self
                delegate.simultaneousRecognitionPolicy = .never
            }).asObservable())
            .when(.recognized)
            .withUnretained(self)
            .bind { vc, _ in
                vc.hide()
            }.disposed(by: disposeBag)
        
        bottomSheetView.rx.panGesture()
            .withUnretained(self)
            .bind { vc, gesture in
                let transition = gesture.translation(in: vc.bottomSheetView)
                
                guard transition.y > 0.0 else { return }
                
                switch gesture.state {
                case .changed:
                    vc.bottomSheetView.snp.updateConstraints {
                        $0.top.equalToSuperview().inset(vc.topInset + transition.y)
                    }
                case .ended:
                    if (transition.y < vc.bottomSheetView.bounds.height / 4) {
                        vc.show()
                    } else {
                        vc.hide()
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addBottomSheetViewSubComponents()
    }
    
    private func setConstraints() {
        makeBottomSheetViewConstraints()
        makeGabberConstraints()
    }
}

extension BottomSheetViewController {
    private func addViewSubComponents() { view.addSubview(bottomSheetView) }
    
    private func makeBottomSheetViewConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomSheetViewSubComponents() { bottomSheetView.addSubview(garbber) }
    
    private func makeGabberConstraints() {
        garbber.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(BottomSheetViewControllerNameSpace.garbberTopInset)
            $0.width.equalTo(BottomSheetViewControllerNameSpace.garbberWidth)
            $0.height.equalTo(BottomSheetViewControllerNameSpace.garbberHeight)
        }
    }
}

extension BottomSheetViewController {
    func show(completion: @escaping () -> Void = {}) {
        bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(topInset) }
        
        UIView.animate(withDuration: BottomSheetViewControllerNameSpace.bottomSheetViewAnimateDuration,
                       delay: BottomSheetViewControllerNameSpace.bottomSheetViewAnimateDelay,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            view.backgroundColor = .black.withAlphaComponent(BottomSheetViewControllerNameSpace.backgroundColorAlpha)
            view.layoutIfNeeded()
        })
        
        dismiss.accept(false)
    }
    
    func hide(completion: @escaping () -> Void = {}) {
        bottomSheetView.snp.updateConstraints { $0.top.equalToSuperview().inset(UIScreen.main.bounds.height) }
        
        UIView
            .animate(withDuration: BottomSheetViewControllerNameSpace.bottomSheetViewAnimateDuration,
                     delay: BottomSheetViewControllerNameSpace.bottomSheetViewAnimateDelay,
                     options: .curveEaseInOut,
                     animations: { [weak self] in
                guard let self = self else { return }
                view.backgroundColor = .clear
                view.layoutIfNeeded()
            })

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BottomSheetViewControllerNameSpace.bottomSheetViewAnimateDuration) { [weak self] in
            guard let self = self else { return }

            dismiss.accept(true)
        }
    }
}

extension BottomSheetViewController {
    func setTopInset(_ inset: CGFloat) {
        self.topInset = inset
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.bottomSheetView) == false else { return false }
        
        return true
    }
}

#if DEBUG

import SwiftUI

struct BottomSheetViewController_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct BottomSheetViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let v = BottomSheetViewController()
            v.setTopInset(500)
            
            return v
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
