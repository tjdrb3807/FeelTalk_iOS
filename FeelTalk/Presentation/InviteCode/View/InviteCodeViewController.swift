//
//  InviteCodeViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InviteCodeViewController: UIViewController {
    var viewModel: InviteCodeViewModel!
    
    private let disposeBag = DisposeBag()

    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .inviteCode) }()
    private lazy var infoPhraseView: InviteCodeInfoPhraseView = { InviteCodeInfoPhraseView() }()
    private lazy var noteBackgroundView: NoteBackgroundView = { NoteBackgroundView() }()
    private lazy var coupleCodeNoteView: CoupleCodeNoteView = { CoupleCodeNoteView() }()
    
    private lazy var presentBottomSheetViewButton: UIButton = {
        let button = UIButton()
        button.setTitle(InviteCodeNameSpace.inputCodeButtonTitleText, for: .normal)
        button.titleLabel?.font = UIFont(name: InviteCodeNameSpace.inputCodeButtonTitleTextFont,
                                         size: InviteCodeNameSpace.inputCodeButtonTitleTextSize)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = InviteCodeNameSpace.inputCodeButtonHeight / 2
        button.backgroundColor = .black
    
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setAttribute()
        self.addSubComponents()
        self.setConfiguration()
        
        self.coupleCodeNoteView.coupleCodeCopyButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                UIPasteboard.general.string = vm.coupleCodeNoteView.coupleCodeLabel.text
            }).disposed(by: disposeBag)
    }
    
    private func bind(to viewModel: InviteCodeViewModel) {
        let input = InviteCodeViewModel.Input(viewDidLoad: self.rx.viewWillAppear,
                                              tapPresentBottomSheetViewButton: presentBottomSheetViewButton.rx.tap)
        
        let output = viewModel.transfer(input: input)
        
        output.inviteCode
            .bind(to: coupleCodeNoteView.coupleCodeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        [navigationBar,
         infoPhraseView,
         noteBackgroundView,
         coupleCodeNoteView,
         presentBottomSheetViewButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConfiguration() {
        makeNavigationBarConstraints()
        makeInfoPhraseViewConstraints()
        makeNoteBackgroundViewConstraints()
        makeInviteCodeNoteViewMakeConstraints()
        makeInputCodeButtonConstraints()
    }
}

extension InviteCodeViewController {
    func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpFlowNavigationBarNameSpace.navigationBarHeight)
        }
    }
    
    func makeInfoPhraseViewConstraints() {
        infoPhraseView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(InviteCodeNameSpace.inviteCodeInfoPhraseViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(InviteCodeNameSpace.baseHorizontalInset)
            $0.height.equalTo(InviteCodeNameSpace.inviteCodeINfoPhraseViewHeight)
        }
    }
    
    func makeNoteBackgroundViewConstraints() {
        noteBackgroundView.snp.makeConstraints {
            $0.top.equalTo(infoPhraseView.snp.bottom).offset(InviteCodeNameSpace.noteBackgroundViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(InviteCodeNameSpace.noteBackgroundViewBottomOffest)
        }
    }
    
    func makeInviteCodeNoteViewMakeConstraints() {
        coupleCodeNoteView.snp.makeConstraints {
            $0.top.equalTo(infoPhraseView.snp.bottom).offset(InviteCodeNameSpace.inviteCodeNoteViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(InviteCodeNameSpace.inviteCodeNoteViewHorizontalInset)
        }
    }
    
    func makeInputCodeButtonConstraints() {
        presentBottomSheetViewButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(InviteCodeNameSpace.baseHorizontalInset)
            $0.height.equalTo(InviteCodeNameSpace.inputCodeButtonHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct InviteCodeViewConroller_Previews: PreviewProvider {
    static var previews: some View {
        InviteCodeViewConroller_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct InviteCodeViewConroller_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            InviteCodeViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
