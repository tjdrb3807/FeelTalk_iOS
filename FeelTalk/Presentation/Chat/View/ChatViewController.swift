//
//  ChatViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatViewController: UIViewController {
    var viewModel: ChatViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var chatRoomButton: CustomChatRoomButton = { CustomChatRoomButton() }()
    
    private lazy var chatRoomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = ChatViweNameSpace.chatRoomViewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: ChatViweNameSpace.chatRoomViewTipStartX,
                              y: ChatViweNameSpace.chatRoomViewTipStartY))
        path.addLine(to: CGPoint(x: ChatViweNameSpace.chatRoomViewTipEndWidth,
                                 y: -ChatViweNameSpace.chatRoomViewTipHeight))
        path.addLine(to: CGPoint(x: ChatViweNameSpace.chatRoomViewTipThirdX,
                                 y: ChatViweNameSpace.chatRoomViewTipThirdY))
        path.addLine(to: CGPoint(x: ChatViweNameSpace.chatRoomViewTipFourthX,
                                 y: ChatViweNameSpace.chatRoomViewTipFourthY))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        
        view.layer.insertSublayer(shape, at: ChatViweNameSpace.chatRoomViewTipInsertAt)
        view.layer.masksToBounds = false
    
        return view
    }()
    
    fileprivate lazy var navigationBar: ChatNavigationBar = { ChatNavigationBar() }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        return collectionView
    }()

    fileprivate lazy var chatInputView: ChatInputView = { ChatInputView() }()
    
    private lazy var chatFucntionView: ChatFunctionView = { ChatFunctionView() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sigleTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                               action: #selector(myTapMethod))
        sigleTapGestureRecognizer.numberOfTapsRequired = 1
        sigleTapGestureRecognizer.isEnabled = true
        sigleTapGestureRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(sigleTapGestureRecognizer)
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    @objc private func myTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bind(to viewModel: ChatViewModel) {
        let input = ChatViewModel.Input(
            tapInputButton: chatInputView.inputButton.rx.tap.asObservable(),
            messageText: chatInputView.messageInputView.messageInputTextView.rx.text.orEmpty.asObservable(),
            tapFunctionButton: chatInputView.functionButton.rx.tap.asObservable(),
            viewWillAppear: self.rx.viewWillAppear
        )
            
        let output = viewModel.transfer(input: input)
        
        output.keyboardHeight
            .withUnretained(self)
            .bind(onNext: { vc, keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + vc.view.safeAreaInsets.bottom : 0
                vc.updateKeyboardHeight(height)
            }).disposed(by: disposeBag)
        
        output.inputMode
            .withUnretained(self)
            .bind { vc, mode in
                if mode == .recordingDescription { vc.dismissKeyboard() }
                vc.chatInputView.mode.accept(mode)
            }
            .disposed(by: disposeBag)
        
        chatInputView.messageInputView.messageInputTextView.rx.didBeginEditing
            .withLatestFrom(output.isFunctionActive)
            .filter { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                // TODO: functionView 내리기
            }.disposed(by: disposeBag)
        
        output.isFunctionActive
            .bind(to: chatInputView.isFunctionActive)
            .disposed(by: disposeBag)
        
        output.isFunctionActive
            .filter { $0 }
            .withLatestFrom(output.inputMode)
            .filter { $0 == .basics || $0 == .inputMessage }
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismissKeyboard()
                guard !vc.view.subviews.contains(where: { $0 is ChatFunctionView }) else { return }
                let functionView = vc.chatFucntionView
                vc.view.addSubview(functionView)
                functionView.snp.makeConstraints {
                    $0.top.equalTo(functionView.snp.bottom).offset(-ChatFunctionViewNameSpace.height)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
                vc.view.layoutIfNeeded()
                functionView.showWithAnimation()
                vc.updateChatFunctionViewHeight()
            }.disposed(by: disposeBag)
        
        output.isFunctionActive
            .withLatestFrom(output.inputMode) { (isFucntionActive: $0, inputMode: $1) }
            .filter { $0.inputMode != .basics && $0.inputMode == .inputMessage }
            .map { $0.isFucntionActive }
            .bind(to: chatInputView.isFunctionActive)
            .disposed(by: disposeBag)
            
        output.partnerNickname
            .bind(to: navigationBar.partnerNickname)
            .disposed(by: disposeBag)
        
//        output.chatModelList
//            .asDriver(onErrorJustReturn: [])
//            .drive(collectionView.rx.items) { [weak self] cv, row, item in
//                guard let self = self else { return UICollectionViewCell() }
//                let index = IndexPath(row: row, section: 0)
//
//                switch item.type {
//                case .challengeChatting:
//                    break
//                case .imageChatting:
//                    break
//                case .questionChatting:
//                    break
//                case .textChatting:
//                    guard let cell = cv.dequeueReusableCell(withReuseIdentifier: "TextChatCell",
//                                                            for: index) as? TextChatCell else { return UICollectionViewCell() }
//                    let model = item as! TextChatModel
//                    cell.model.accept(model)
//
//                    return cell
//                case .voiceChatting:
//                    break
//                }
//
//
//
//                return UICollectionViewCell()
//            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        view.backgroundColor = .black.withAlphaComponent(ChatViweNameSpace.backgroundColorAlpha)
    }
    
    private func addSubComponents() {
        addChatViewSubComponents()
        addChatRoomViewSubComponents()
    }
    
    private func setConstraints() {
        makeChatRoomButtonConstraints()
        makeChatRoomViewConstraints()
        makeNavigationBarConstraints()
        makeCollectionViewConstraints()
        makeChatInputViewConstraints()
    }
}

extension ChatViewController {
    private func addChatViewSubComponents() {
        [chatRoomButton, chatRoomView].forEach { view.addSubview($0) }
    }
    
    private func makeChatRoomButtonConstraints() {
        chatRoomButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ChatViweNameSpace.chatRoomButtonTopOffset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.width.equalTo(CustomChatRoomButtonNameSpace.profileImageViewWidth)
            $0.height.equalTo(CustomChatRoomButtonNameSpace.profileImageViewHeight)
        }
    }
    
    private func makeChatRoomViewConstraints() {
        chatRoomView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ChatViweNameSpace.chatRoomViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func addChatRoomViewSubComponents() {
        [navigationBar, collectionView, chatInputView].forEach { chatRoomView.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChatNavigationBarNameSpace.height)
        }
    }
    
    private func makeCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(chatInputView.snp.top)
        }
    }
    
    private func makeChatInputViewConstraints() {
        chatInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Utils.safeAreaBottomInset())
        }
    }
}

extension ChatViewController {
    private func updateKeyboardHeight(_ keyboardHeight: CGFloat) {
        chatRoomView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(keyboardHeight) }
    
        view.layoutIfNeeded()
    }
    
    private func updateChatFunctionViewHeight() {
        chatRoomView.snp.updateConstraints { $0.bottom.equalToSuperview().inset(ChatFunctionViewNameSpace.height) }
        chatInputView.snp.updateConstraints { $0.bottom.equalToSuperview() }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: view.layoutIfNeeded)
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 120)
    }
}

#if DEBUG

import SwiftUI

struct ChatViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ChatViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = ChatViewController()
            let vm = ChatViewModel(coordinator: DefaultChatCooridnator(UINavigationController()),
                                   userUseCase: DefaultUserUseCase(
                                    userRepository: DefaultUserRepository()),
                                   chatUseCase: DefaultChatUseCase(
                                    chatRepository: DefaultChatRepository()))
            
            vc.viewModel = vm
            vc.navigationBar.partnerNickname.accept("partner")
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
