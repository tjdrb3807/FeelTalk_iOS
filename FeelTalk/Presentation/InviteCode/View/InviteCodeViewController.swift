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
    private var viewModel: InviteCodeViewModel!
    
    private let disposeBag = DisposeBag()
    
    private lazy var viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = InviteCodeNameSpace.viewTitleLabelText
        label.textColor = .black
        label.font = UIFont(name: InviteCodeNameSpace.viewTitleLabelTextFont,
                            size: InviteCodeNameSpace.viewTitleLabelTextSize)
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        return label
    }()
    
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
        [viewTitleLabel,
         infoPhraseView,
         noteBackgroundView,
         coupleCodeNoteView,
         presentBottomSheetViewButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConfiguration() {
        makeViewTitleLableConstraints()
        makeInfoPhraseViewConstraints()
        makeNoteBackgroundViewConstraints()
        makeInviteCodeNoteViewMakeConstraints()
        makeInputCodeButtonConstraints()
    }
}

extension InviteCodeViewController {
    final class func create(with viewModel: InviteCodeViewModel) -> InviteCodeViewController {
        let viewController = InviteCodeViewController()
        viewController.viewModel = viewModel

        return viewController
    }
}

extension InviteCodeViewController {
    func makeViewTitleLableConstraints() {
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(InviteCodeNameSpace.viewTitleLabelHeight)
        }
    }
    func makeInfoPhraseViewConstraints() {
        infoPhraseView.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom).offset(InviteCodeNameSpace.inviteCodeInfoPhraseViewTopOffset)
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
            $0.bottom.equalTo(presentBottomSheetViewButton.snp.top).offset(InviteCodeNameSpace.inviteCodeNoteViewBottomOffset)
        }
    }
    
    func makeInputCodeButtonConstraints() {
        presentBottomSheetViewButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom)
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
    }
    
    struct InviteCodeViewConroller_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            InviteCodeViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
