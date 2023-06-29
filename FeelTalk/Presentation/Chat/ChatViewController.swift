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
    private let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    var messages: [(message: String, chatSender: TestChatModel.ChatSender)] = []

    private lazy var topBar = ChatViewTopSectionBar()
    
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
    
    private lazy var bottomBar = ChatViewBottomSectionBar()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func bindViewModel() {
        let input = ChatViewModel.Input.init(viewWillAppearObserver: self.rx.viewWillAppear,
                                             viewWillDisappearObserver: self.rx.viewWillDisappear,
                                             bottomBarInputTextViewTextObserver: bottomBar.inputTextView.rx.text.orEmpty,
                                             bottomBarInputTextViewBegineEditingObserver: bottomBar.inputTextView.rx.didBeginEditing,
                                             bottomBarInputTextViewEndEditingObserver: bottomBar.inputTextView.rx.didEndEditing,
                                             tapBottomBarTextViewInnerButton: bottomBar.textViewInnerButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.bottomBarTextViewInnerButtonStateObserver
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                bottomBar.textViewInnerButton.rx.isEnabled.onNext($0.0)
                bottomBar.textViewInnerButton.rx.image().onNext($0.1)
            }).disposed(by: disposeBag)
    }
    
    override func setAttribute() {
        // TEST
        self.messages = Mock.getMockMessages()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        // MARK: Set tabBar Shadow
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.08
        topBar.layer.shadowRadius = 0.5
        topBar.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0.0,
                                                            y: (UIScreen.main.bounds.height / 100) * 7.389,
                                                            width: UIScreen.main.bounds.width,
                                                            height: 1.0)).cgPath
    }
    
    override func setConfig() {
        view.addSubview(topBar)

        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.38)
        }
        
        [chatListView, bottomBar].forEach { keyboardSafeAreaView.addSubview($0) }
        
        chatListView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 7.38)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 8.12)
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

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        
        return ControlEvent(events: source)
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
