//
//  ChallengeOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// ChallengeOpenGraphType == .add || .ongoing
final class ChallengeOpenGraph: UIView {
    let modelObserver = PublishRelay<ChallengeChat>()
    private let disposeBag = DisposeBag()
    
    private lazy var totalContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeOpenGraphNameSpace.totalContentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        modelObserver
            .map { model -> ChatType in model.type }
            .map { type -> String in
                switch type {
                case .addChallengeChatting:
                    return ChallengeOpenGraphNameSpace.flagImageAddChallengeType
                case .challengeChatting:
                    return ChallengeOpenGraphNameSpace.flagImageChallengeType
                default:
                    return ChallengeOpenGraphNameSpace.flageImageDefaultType
                }
            }.map { imageStr -> UIImage? in UIImage(named: imageStr) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardMedium,
            size: ChallengeOpenGraphNameSpace.titleLabelFontSize
        )
        
        modelObserver
            .map { model -> ChatType in model.type }
            .map { type -> String? in
                switch type {
                case .addChallengeChatting:
                    return "새로운 챌린지를 등록했어요!"
                case .challengeChatting:
                    return "챌린지를 진행하고 있어요!"
                default:
                    return nil
                }
            }.bind { text in
                label.rx.text.onNext(text)
                label.setLineHeight(height: 24.0)
            }.disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4.0
        
        return stackView
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.main500)
        label.textAlignment = .center
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 12.0)
        label.backgroundColor = UIColor(named: CommonColorNameSpace.main300)
        label.layer.cornerRadius = 8.0
        label.clipsToBounds = true
        
        modelObserver
            .map { model -> String in model.challengeDeadline }
            .map { String.replaceT($0) }
            .bind {
                guard let deadline = Date.strToDate($0) else { return }
                let dDay = Utils.calculateDday(deadline)
                
                label.rx.text.onNext(dDay)
            }.disposed(by: disposeBag)
        
        return label
    }()
    
    private lazy var challengeContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 14.0)
        
        modelObserver
            .map { model -> String? in model.challengeTitle }
            .bind { text in
                guard var text = text else { return }
                if text.count > 10 {
                    let index = text.index(text.startIndex, offsetBy: 10)
                    text.insert("\n", at: index)
                }
                label.rx.text.onNext(text)
                label.setLineHeight(height: 21.0)
            }.disposed(by: disposeBag)

        return label
    }()
    
    lazy var presentChallengeButton: UIButton = {
        let button = UIButton()
        button.setTitle("보러가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(
            name: CommonFontNameSpace.pretendardRegular,
            size: 16.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = 40.0 / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 250.0,
                    height: 308.0)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    init(onClickButton: @escaping () -> Void) {
        super.init(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 250.0,
                    height: 308.0)))
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        
        presentChallengeButton.addAction {
            onClickButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTotalContentStackViewSubComponents()
        addContentViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalContentStackViewConstraints()
        makeFlagImageConstraints()
        makeContentViewConstraints()
        makeContentStackViewConstraints()
        makeDdayLabelConstraints()
        makePresentChallengeButtonConstraints()
        makeTitleLabelConstraints()
    }
}

extension ChallengeOpenGraph {
    private func addViewSubComponents() { addSubview(totalContentStackView) }
    
    private func makeTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(24.0)
        }
    }
    
    private func makeTotalContentStackViewConstraints() {
        totalContentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addTotalContentStackViewSubComponents() {
        [flagImage, titleLabel, contentView, presentChallengeButton].forEach { totalContentStackView.addArrangedSubview($0) }
    }
    
    private func makeFlagImageConstraints() {
        flagImage.snp.makeConstraints {
            $0.width.equalTo(84.0)
            $0.height.equalTo(84.0)
        }
    }
    
    private func addContentViewSubComponents() {
        contentView.addSubview(contentStackView)
    }
    
    private func makeContentViewConstraints() {
        contentView.snp.makeConstraints {
            $0.width.equalTo(226.0)
            $0.height.equalTo(92.0)
        }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addContentStackViewSubComponents() {
        [dDayLabel, challengeContentLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeDdayLabelConstraints() {
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(52.0)
            $0.height.equalTo(30.0)
        }
    }
    
    private func makePresentChallengeButtonConstraints() {
        presentChallengeButton.snp.makeConstraints {
            $0.width.equalTo(226.0)
            $0.height.equalTo(40.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeOpenGraph_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeOpenGraph_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 250.0,
                height: 308.0,
                alignment: .center)
    }
    
    struct ChallengeOpenGraph_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeOpenGraph()
            v.modelObserver.accept(
                ChallengeChat(index: 0, type: .challengeChatting, isRead: false, isMine: false, createAt: "2024-01-01T12:00:00", challengeIndex: 0, challengeTitle: "다섯글자임다섯글자임다섯글자임다섯글자임", challengeDeadline: "2025-01-01T12:00:00")
            )
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
