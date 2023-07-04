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

final class ChatViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ChatViewModel()
    var messages: [(message: String, chatSender: TestChatModel.ChatSender)] = []
    
    private lazy var fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
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
        stackView.alignment = .center
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
        label.font = UIFont(name: "pretendard-medium", size: ChatViewNameSpace.partnerNameLabelFontSize)
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
        stackView.spacing = ChatViewNameSpace.bottomBarSpacing
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
    ///     - additionalFunctionButton
    ///     - buttomBarContentVerticalStackView
    private lazy var bottomBarFullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        stackView.spacing = ChatViewNameSpace.bottomBarFullHorizontalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var additionalFunctionButton: UIButton = {
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
        stackView.spacing = ChatViewNameSpace.bottomBarContentVerticalStackViewSpacing
        stackView.backgroundColor = UIColor(named: "gray_100")
        stackView.layer.borderColor = UIColor(named: "gray_300")?.cgColor
        stackView.layer.borderWidth = ChatViewNameSpace.bottomBarContentVerticalStackViewBorderWidth
        stackView.layer.cornerRadius = ChatViewNameSpace.bottomBarContentVerticalStackViewCornerRadius
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
        stackView.spacing = ChatViewNameSpace.bottomBarcontentHorizontalStackViewSpacing
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
        textView.font = UIFont(name: "pretendard-regular", size: ChatViewNameSpace.inputTextViewFontSize)
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
        button.layer.cornerRadius = ChatViewNameSpace.transferButtonCornerRadius
        
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
    
    private lazy var additinoalFunctionView: BaseView = {
        let view = ChatAdditionalFunctionView()
        
        return view
    }()
    
    // MARK: Override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setAttribute()
        self.addSubViews()
        self.setConfig()
        self.bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func bindViewModel() {
        let input = ChatViewModel.Input(additionalFunctionButtonTapObserver: additionalFunctionButton.rx.tap,
                                        inputTextViewBeginEdtingObserver: inputTextView.rx.didBeginEditing,
                                        inputTextViewEndEditingObserver: inputTextView.rx.didEndEditing,
                                        inputTextViewTextObserver: inputTextView.rx.text.orEmpty,
                                        transferButtonTapObserver: transferButton.rx.tap)


        let output = viewModel.transform(input: input)
        

        output.keyboardHeightObservable
            .withUnretained(self)
            .bind(onNext: { chatVC, keyboardHeight in
                chatVC.updateKeyboardHeight(keyboardHeight)
            }).disposed(by: disposeBag)
            
        
//        output.additionalFunctionViewHeight
//            .drive(onNext: { [weak self] height in
//                guard let self = self else { return }
//                self.setAdditionalFunction(height: height)
//            }).disposed(by: disposeBag)

    }
    
    func setAttribute() {
        // TEST
        self.messages = Mock.getMockMessages()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    func addSubViews() {
        self.topBarAddSubView()
        self.chatListAddSubView()
        self.bottomBarAddSubViews()
        self.fullStackViewAddSubView()
    }
    
    func setConfig() {
        self.topBarMakeConstraints()
        self.bottomBarMakeConstraints()
        self.fullStackViewMakeConstraints()
    }
    
    // MARK: Default setting method for ChatView
    private func topBarAddSubView() {
        [partnerNameLabel, chatMenuButton].forEach { topBarFullHorizontalStackView.addArrangedSubview($0) }
        
        topBar.addSubview(topBarFullHorizontalStackView)
    }
    
    private func topBarMakeConstraints() {
        chatMenuButton.snp.makeConstraints { $0.width.equalTo(chatMenuButton.snp.height) }

        topBarFullHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(ChatViewNameSpace.topBarVerticalSpacing)
            $0.leading.equalToSuperview().inset(ChatViewNameSpace.topBarLeftSpacerWidth)
            $0.trailing.equalToSuperview().inset(ChatViewNameSpace.topBarRightSpacerWidth)
            $0.centerY.equalToSuperview()
        }
        
        topBar.snp.makeConstraints { $0.height.equalTo(ChatViewNameSpace.topBarHeight) }
    }
    
    private func chatListAddSubView() {
        fullStackView.addArrangedSubview(chatListView)
    }
    
    private func bottomBarAddSubViews() {
        [bottomBarContentHorizontalStackViewLeftSpace, inputTextView,
         bottomBarContentHorizontalStackViewMiddleSpace, transferButton,
         bottomBarContentHorizontalStackViewRightSpace].forEach { bottomBarContentHorizontalStackView.addArrangedSubview($0) }
        
        [bottomBarContentVerticalStackViewTopSpace, bottomBarContentHorizontalStackView, bottomBarContentVerticalStackViewBottomSpace].forEach { bottomBarContentVerticalStackView.addArrangedSubview($0) }

        [additionalFunctionButton, bottomBarContentVerticalStackView, bottomBarFullHorizontalStackViewRightSpace].forEach { bottomBarFullHorizontalStackView.addArrangedSubview($0) }

        [bottomBarTopSpace, bottomBarFullHorizontalStackView, bottomBarBottomSpace].forEach { bottomBar.addArrangedSubview($0) }
        
        view.addSubview(bottomBar)
    }
    
    private func bottomBarMakeConstraints() {
        inputTextView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewLeftSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.bottomBarContentHorizontalStackViewLeftSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewMiddleSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.bottomBarContentHorizontalStackViewMiddleSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarContentHorizontalStackViewRightSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.btttomBarContenthorizontalStackViewRightSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        transferButton.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.transferButtonWidth)
            $0.height.equalTo(transferButton.snp.width)
        }
        
        bottomBarContentVerticalStackViewTopSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewNameSpace.bottomBarContentVerticalStackViewTopSpaceHeight)
        }
        
        bottomBarContentVerticalStackViewBottomSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewNameSpace.bottomBarContentVerticalStackViewBottomSpace)
        }
        
        additionalFunctionButton.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.additionalFunctionButtonWidth)
            $0.height.equalTo(additionalFunctionButton.snp.width)
        }
        
        bottomBarFullHorizontalStackViewRightSpace.snp.makeConstraints {
            $0.width.equalTo(ChatViewNameSpace.bottomBarFullHorizontalStackViewRightSpaceWidth)
            $0.height.equalToSuperview()
        }
        
        bottomBarTopSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewNameSpace.bottomBarTopSpaceHeight)
        }
        
        bottomBarBottomSpace.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChatViewNameSpace.bottomBarBottomSpaceHeight)
        }
    }
    
    private func fullStackViewAddSubView() {
        [topBar, chatListView, bottomBar].forEach { fullStackView.addArrangedSubview($0) }
        
        view.addSubview(fullStackView)
    }
    
    private func fullStackViewMakeConstraints() {
        fullStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Observable inner method

extension ChatViewController {
    private func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        fullStackView.snp.updateConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight) }
        view.layoutIfNeeded()
    }
}
//extension ChatViewController {
//    private func setAdditionalFunction(height: CGFloat) {
//        if height > 0 {
//            additionalFunctionButton.rx.image().onNext((UIImage(named: "icon_cancel")))
//
//            view.addSubview(additinoalFunctionView)
//
//            additinoalFunctionView.snp.makeConstraints {
//                $0.leading.trailing.bottom.equalToSuperview()
//                $0.height.equalTo(height)
//            }
//
//            bottomBar.snp.remakeConstraints {
//                $0.leading.trailing.equalToSuperview()
//                $0.bottom.equalTo(additinoalFunctionView.snp.top)
//            }
//
//            view.endEditing(true)
//        } else {
//            additionalFunctionButton.rx.image().onNext((UIImage(named: "icon_plus")))
//
//            additinoalFunctionView.removeFromSuperview()
//
//            keyboardSafeAreaView.addSubview(bottomBar)
//
//            bottomBar.snp.remakeConstraints {
//                $0.leading.trailing.bottom.equalToSuperview()
//            }
//        }
//    }
//}



//extension ChatViewController {
//    private func setAdditionalFunctionViewHeight(height: CGFloat) {
//        if height > 0 {
//            view.addSubview(additinoalFunctionView)
//
//            additinoalFunctionView.snp.makeConstraints {
//                $0.leading.trailing.bottom.equalToSuperview()
//                $0.height.equalTo(height)
//            }
//
//            bottomBar.snp.remakeConstraints {
//                $0.leading.trailing.equalToSuperview()
//                $0.bottom.equalTo(additinoalFunctionView.snp.top)
//            }
//        } else {
//            additinoalFunctionView.removeFromSuperview()
//
//            bottomBar.snp.remakeConstraints {
//                $0.leading.trailing.bottom.equalToSuperview()
//            }
//        }
//    }
//
//    private func setAttributeAdditionalFunctionButton(state: Bool) {
//        state ? additionalFunctionButton.rx.image().onNext(UIImage(named: "icon_cancel")) : additionalFunctionButton.rx.image().onNext((UIImage(named: "icon_plus")))
//    }
//
//    private func setAttributeBasedOnChatViewState(state: ChatViewState) {
//        switch state {
//        case .activeSendChat:
//            transferButton.rx.image().onNext(UIImage(named: "icon_chat_send_active"))
//            transferButton.rx.backgroundColor.onNext(UIColor.clear)
//            bottomBarContentVerticalStackView.rx.backgroundColor.onNext(UIColor(named: "gray_100"))
//            bottomBarContentVerticalStackView.layer.rx.borderColor.onNext(UIColor(named: "gray_300")?.cgColor)
//        case .activeSendVoiceRecode:
//            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_send"))
//            transferButton.rx.backgroundColor.onNext(UIColor.white)
//            bottomBarContentVerticalStackView.rx.backgroundColor.onNext(UIColor(named: "main_500"))
//            bottomBarContentVerticalStackView.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
//        case .activeVoiceRecode:
//            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_active"))
//            transferButton.rx.backgroundColor.onNext(UIColor(named: "main_500"))
//            bottomBarContentVerticalStackView.rx.backgroundColor.onNext(UIColor(named: "main_300"))
//            bottomBarContentVerticalStackView.layer.rx.borderColor.onNext((UIColor(named: "main_400")?.cgColor))
//        case .inActiveVoiceRecode:
//            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_inactive"))
//            transferButton.rx.backgroundColor.onNext(UIColor.clear)
//            bottomBarContentVerticalStackView.rx.backgroundColor.onNext(UIColor(named: "gray_100"))
//            bottomBarContentVerticalStackView.layer.rx.borderColor.onNext(UIColor(named: "gray_300")?.cgColor)
//        case .pauseVoiceRecode:
//            transferButton.rx.image().onNext(UIImage(named: "icon_voice_recode_pause"))
//            transferButton.rx.backgroundColor.onNext(UIColor.white)
//            bottomBarContentVerticalStackView.rx.backgroundColor.onNext(UIColor(named: "main_500"))
//            bottomBarContentVerticalStackView.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
//        }
//    }
//}

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
            .edgesIgnoringSafeArea(.bottom)
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
