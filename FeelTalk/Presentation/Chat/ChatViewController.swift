//
//  ChatViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class ChatViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ChatViewModel()
    var messages: [(message: String, chatSender: TestChatModel.ChatSender)] = []
    
    // MARK: ChatView subComponents - topBar
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 0.5
        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0.0,
                                                          y: UIScreen.main.bounds.height / 100 * 7.38,
                                                          width: UIScreen.main.bounds.width,
                                                          height: 1.0)).cgPath
        
        return view
    }()
    
    private lazy var topBarFullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var partnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: "pretendard-medium", size: ChatViewConstraintValueNameSpace.partnerNameLabelFontSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var chatMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_chat_top_menu"), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    // MARK: ChatView subComponents - chatList
    private lazy var chatListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = (UIScreen.main.bounds.height / 100) * 1.97
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatTextMessageCell.self, forCellWithReuseIdentifier: "ChatTextMessageCell")
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: ChatView subComponents - bottomBar
    /// bottomBar view hierarchy
    ///
    /// - subViews
    ///     - bottomBarTopSpace
    ///     - bottomBarFullHorizontalStackView
    ///     - bottomBarBottomSpace
    private lazy var bottomBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = ChatViewConstraintValueNameSpace.bottomBarSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.08
        stackView.layer.shadowRadius = 0.5
        stackView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0.0,
                                                               y: -1.0,
                                                               width: UIScreen.main.bounds.width,
                                                               height: 1.0)).cgPath
        
        return stackView
    }()
    
    private lazy var bottomBarTopSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    /// bottomBarFullHorizontalStackView view hierarchy
    ///
    /// - subViews
    ///     - bottomBarMenuButton
    ///     - buttomBarContentVerticalStackView
    private lazy var bottomBarFullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        stackView.spacing = ChatViewConstraintValueNameSpace.bottomBarFullHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var bottomBarMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    /// bottomBarContentVerticalStackView view hierarchy
    ///
    /// - subViews
    ///     - bottomBarContentVerticalStackViewTopSpace
    ///     - bottomBarContentHorizontalStackView
    ///     - bottomBarContentVerticalStackViewBottomSpace
    private lazy var bottomBarContentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = ChatViewConstraintValueNameSpace.bottomBarContentVerticalStackViewSpacing
        stackView.backgroundColor = UIColor(named: "gray_100")
        stackView.layer.borderColor = UIColor(named: "gray_300")?.cgColor
        stackView.layer.borderWidth = ChatViewConstraintValueNameSpace.bottomBarContentVerticalStackViewBorderWidth
        stackView.layer.cornerRadius = ChatViewConstraintValueNameSpace.bottomBarContentVerticalStackViewCornerRadius
        stackView.clipsToBounds = true
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var bottomBarContentVerticalStackViewTopSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    /// bottomBarContentHorizontalStackView view hierarchy
    ///
    /// - subViews
    ///     - bottomBarContentHorizontalStackViewLeftSpace
    ///     - inputTextView
    ///     - bottomBarContentHorizontalStackViewMiddleSpace
    ///     - transferButton
    ///     - bottomBarContentHorizontalStackViewRightSpace
    private lazy var bottomBarContentHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = ChatViewConstraintValueNameSpace.bottomBarcontentHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var bottomBarContentHorizontalStackViewLeftSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "pretendard-regular", size: ChatViewConstraintValueNameSpace.inputTextViewFontSize)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.textInputView.backgroundColor = .clear
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private lazy var bottomBarContentHorizontalStackViewMiddleSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var transferButton: UIButton = {
        let button = UIButton()
        button.setImage((UIImage(named: "icon_voice_recode_inactive")), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = ChatViewConstraintValueNameSpace.transferButtonCornerRadius
        
        return button
    }()
    
    private lazy var bottomBarContentHorizontalStackViewRightSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var bottomBarContentVerticalStackViewBottomSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var bottomBarFullHorizontalStackViewRightSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var bottomBarBottomSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: Override method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func bindViewModel() {
        let input = ChatViewModel.Input.init(bottomBarMenuButtonTapObserver: bottomBarMenuButton.rx.tap,
                                             inputTextViewBegineEditingObserver: inputTextView.rx.didBeginEditing,
                                             inputTextViewEndEditingObserver: inputTextView.rx.didEndEditing,
                                             inputTextViewTextObserver: inputTextView.rx.text.orEmpty,
                                             transferButtonTapObserver: transferButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.chatViewState
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                self.setAttributeBasedOnChatViewState(state: state)
            }).disposed(by: disposeBag)
    }
    
    override func setAttribute() {
        // TEST
        self.messages = Mock.getMockMessages()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    override func addSubViews() {
        self.topBarAddSubView()
        self.bottomBarAddSubViews()
    }
    
    override func setConfig() {
        self.topBarMakeConstraints()
        self.bottomBarMakeConstraints()
        
//        [chatListView, bottomBar].forEach { keyboardSafeAreaView.addSubview($0) }
//
//        chatListView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 7.38)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(bottomBar.snp.top)
//        }
    }
    
    // MARK: Default setting method for ChatView
    private func topBarAddSubView() {
        [partnerNameLabel, chatMenuButton].forEach { topBarFullHorizontalStackView.addArrangedSubview($0) }
        
        topBar.addSubview(topBarFullHorizontalStackView)
        
        view.addSubview(topBar)
    }
    
    private func topBarMakeConstraints() {
        chatMenuButton.snp.makeConstraints { $0.width.equalTo(chatMenuButton.snp.height) }

        topBarFullHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(ChatViewConstraintValueNameSpace.topBarVerticalSpacing)
            $0.leading.equalToSuperview().inset(ChatViewConstraintValueNameSpace.topBarLeftSpacerWidth)
            $0.trailing.equalToSuperview().inset(ChatViewConstraintValueNameSpace.topBarRightSpacerWidth)
            $0.centerY.equalToSuperview()
        }

        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChatViewConstraintValueNameSpace.topBarHeight)
        }
    }
    
    private func bottomBarAddSubViews() {
        [bottomBarContentHorizontalStackViewLeftSpace, inputTextView,
         bottomBarContentHorizontalStackViewMiddleSpace, transferButton,
         bottomBarContentHorizontalStackViewRightSpace].forEach { bottomBarContentHorizontalStackView.addArrangedSubview($0) }
        
        [bottomBarContentVerticalStackViewTopSpace, bottomBarContentHorizontalStackView, bottomBarContentVerticalStackViewBottomSpace].forEach { bottomBarContentVerticalStackView.addArrangedSubview($0) }

        [bottomBarMenuButton, bottomBarContentVerticalStackView, bottomBarFullHorizontalStackViewRightSpace].forEach { bottomBarFullHorizontalStackView.addArrangedSubview($0) }

        [bottomBarTopSpace, bottomBarFullHorizontalStackView, bottomBarBottomSpace].forEach { bottomBar.addArrangedSubview($0) }
        
        keyboardSafeAreaView.addSubview(bottomBar)
    }
    
    private func bottomBarMakeConstraints() {
        inputTextView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewLeftSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.bottomBarContentHorizontalStackViewLeftSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewMiddleSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.bottomBarContentHorizontalStackViewMiddleSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewRightSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.btttomBarContenthorizontalStackViewRightSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        transferButton.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.transferButtonWidth)
            $0.height.equalTo(transferButton.snp.width)
        }
        
        bottomBarContentVerticalStackViewTopSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewConstraintValueNameSpace.bottomBarContentVerticalStackViewTopSpaceHeight)
        }
        
        bottomBarContentVerticalStackViewBottomSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewConstraintValueNameSpace.bottomBarContentVerticalStackViewBottomSpace)
        }
        
        bottomBarMenuButton.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.bottomBarMenuButtonWidth)
            $0.height.equalTo(bottomBarMenuButton.snp.width)
        }
        
        bottomBarFullHorizontalStackViewRightSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewConstraintValueNameSpace.bottomBarFullHorizontalStackViewRightSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarTopSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewConstraintValueNameSpace.bottomBarTopSpaceHeight)
        }
        
        bottomBarBottomSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewConstraintValueNameSpace.bottomBarBottomSpaceHeight)
        }
        
        bottomBar.snp.makeConstraints { $0.leading.trailing.bottom.equalToSuperview() }
    }
}

extension ChatViewController {
    private func setAttributeBasedOnChatViewState(state: ChatViewState) {
        switch state {
        case .activeSendChat:
            transferButton.rx.image().onNext(UIImage(named: "icon_chat_send_active"))
            transferButton.rx.backgroundColor.onNext(UIColor.clear)
            bottomBarFullHorizontalStackView.rx.backgroundColor.onNext(UIColor(named: "gray_100"))
            bottomBarFullHorizontalStackView.layer.rx.borderColor.onNext(UIColor(named: "gray_300")?.cgColor)
        case .activeSendVoiceRecode:
            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_send"))
            transferButton.rx.backgroundColor.onNext(UIColor.white)
            bottomBarFullHorizontalStackView.rx.backgroundColor.onNext(UIColor(named: "main_500"))
            bottomBarFullHorizontalStackView.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
        case .activeVoiceRecode:
            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_active"))
            transferButton.rx.backgroundColor.onNext(UIColor(named: "main_500"))
            bottomBarFullHorizontalStackView.rx.backgroundColor.onNext(UIColor(named: "main_300"))
            bottomBarFullHorizontalStackView.layer.rx.borderColor.onNext((UIColor(named: "main_400")?.cgColor))
        case .inActiveVoiceRecode:
            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_inactive"))
            transferButton.rx.backgroundColor.onNext(UIColor.clear)
            bottomBarFullHorizontalStackView.rx.backgroundColor.onNext(UIColor(named: "gray_100"))
            bottomBarFullHorizontalStackView.layer.rx.borderColor.onNext(UIColor(named: "gray_300")?.cgColor)
        case .pauseVoiceRecode:
            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_pause"))
            transferButton.rx.backgroundColor.onNext(UIColor.white)
            bottomBarFullHorizontalStackView.rx.backgroundColor.onNext(UIColor(named: "main_500"))
            bottomBarFullHorizontalStackView.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
        }
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatTextMessageCell", for: indexPath) as? ChatTextMessageCell else { return UICollectionViewCell() }
        let message = messages[indexPath.row]
        cell.model = .init(message: message.message, chatSender: message.chatSender, isRead: true)
        
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedFram = messages[indexPath.row].message.getEstimatedFrame(with: .systemFont(ofSize: 16.0))
        
//        let plusFram = messages[indexPath.row].chatSender == .partner ? (UIScreen.main.bounds.height / 100) *
        
        return CGSize(width: view.bounds.width, height: estimatedFram.height + 80)
    }
}

#if DEBUG

import SwiftUI

struct ChatViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewController_Presentable()
    }
    
    struct ChatViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            ChatViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif

class Mock {
    static func getMockMessages() -> [(message: String, chatSender: TestChatModel.ChatSender)] {  //Test
        let messages = ["바람 불어와 내 맘 흔들면",
                        "지나간 세월에",
                        "두 눈을 감아본다",
                        "나를 스치는 고요한 떨림",
                        "그 작은 소리에",
                        "난 귀를 기울여 본다",
                        "내 안에 숨쉬는\n커버린 삶의 조각들이\n날 부딪혀 지날 때\n그 곳을 바라보리라",
                        "우리의 믿음 우리의 사랑 그 영원한 약속들을 나 추억한다면 힘차게 걸으리라",
                        "우리의 만남 우리의 이별\n그 바래진 기억에\n나 사랑했다면 미소를 띄우리라\n내 안에 있는\n모자란 삶의 기억들이\n날 부딪혀 지날 때\n그 곳을 바라보리라\n우리의 믿음 우리의 사랑\n그 영원한 약속들을\n나 추억한다면 힘차게 걸으리라",
        ]
//        return messages.map { ($0, ChatTextMessageCell.ChatType.allCases.randomElement()!) }
        
        return messages.map { ($0, TestChatModel.ChatSender.allCases.randomElement()!) }
        
//        return messages.map { ($0, ChatModel.ChatSender.my) }
    }
}
