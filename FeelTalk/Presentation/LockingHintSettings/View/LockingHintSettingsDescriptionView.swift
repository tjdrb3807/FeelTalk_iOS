//
//  LockingHintSettingsDescriptionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LockingHintSettingsDescriptionView: UIStackView {
    private let disposeBag = DisposeBag()
    let viewMode = PublishRelay<LockingHintSettingsViewMode>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     암호를 잊어버렸을 때
                     어떤 질문으로 찾으시겠어요?
                     """
        label.textColor = .black
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 24.0)
        label.setLineHeight(height: 36)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     질문을 선택하면 암호를 잊어버렸을 때
                     암호를 빠르게 재설정할 수 있어요.
                     """
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 16.0)
        label.setLineHeight(height: 24.0)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.addSubcomponents(with: mode)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = 4
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
}

extension LockingHintSettingsDescriptionView {
    private func addSubcomponents(with mode: LockingHintSettingsViewMode) {
        switch mode {
        case .settings:
            [titleLabel, subTitleLabel].forEach { addArrangedSubview($0) }
        case .input:
            addArrangedSubview(titleLabel)
        }
    }
}

#if DEBUG

import SwiftUI

struct LockingHintSettingsDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        LockingHintSettingsDescriptionView_Presentable()
    }
    
    struct LockingHintSettingsDescriptionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = LockingHintSettingsDescriptionView()
            view.viewMode.accept(.settings)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
