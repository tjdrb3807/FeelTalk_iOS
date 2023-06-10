//
//  CoupleCodeCreateViewConroller.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CoupleCodeCreateViewConroller: UIViewController {
    private lazy var labelVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연인에게 보낼 초대장을 준비했어요"
        label.font = UIFont(name: "pretendard-medium", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subscriptLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방에게 코드를 공유해 기기를 연결해주세요."
        label.font = UIFont(name: "pretendard-regular", size: 16.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var noteBackgroundView = NoteBackgroundView()
    
    private lazy var coupleCodeNoteView = CoupleCodeNoteView()
    
    private lazy var pushCoupleCodeInputViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("상대방 코드를 직접 입력할게요", for: .normal)
        button.titleLabel?.font = UIFont(name: "pretendard-medium", size: 18.0)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 7.26) / 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
    }
    
    private func setConfig() {
        [titleLabel, subscriptLabel].forEach { labelVerticalStackView.addArrangedSubview($0) }
        
        [labelVerticalStackView, noteBackgroundView, coupleCodeNoteView, pushCoupleCodeInputViewButton].forEach { view.addSubview($0) }
        
        labelVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset((UIScreen.main.bounds.height / 100) * 3.57)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.88)
        }
        
        noteBackgroundView.snp.makeConstraints {
            $0.top.equalTo(labelVerticalStackView.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 6.65)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 7.57)
        }
        
        coupleCodeNoteView.snp.makeConstraints {
            $0.top.equalTo(labelVerticalStackView.snp.bottom).offset((UIScreen.main.bounds.height / 100) * 12.56)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 12.0)
            $0.bottom.equalTo(pushCoupleCodeInputViewButton.snp.top).offset(-(UIScreen.main.bounds.height / 100) * 7.26)
        }
        
        pushCoupleCodeInputViewButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(labelVerticalStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26)
        }
    }
}

#if DEBUG

import SwiftUI

struct CoupleCodeCreateViewConroller_Previews: PreviewProvider {
    static var previews: some View {
        CoupleCodeCreateViewConroller_Presentable()
    }
    
    struct CoupleCodeCreateViewConroller_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            CoupleCodeCreateViewConroller()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif
