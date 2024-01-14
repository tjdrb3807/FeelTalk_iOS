//
//  ChallengeDetailToolbar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailToolbar: UIToolbar {
    private var toolbarType: ChallengeToolbarType
    
    var currentPage = 0
    
    private var bannerContents: [ChallengeToolbarBannerContent] = [
        ChallengeToolbarBannerContent(title: "새로운 체위를 찾아보는 건 어때요?", highlight: "새로운 체위"),
        ChallengeToolbarBannerContent(title: "코스프레 판타지가 있나요?", highlight: "코스프레"),
        ChallengeToolbarBannerContent(title: "성인용품으로 색다른 경험을 해볼까요?", highlight: "성인용품"),
        ChallengeToolbarBannerContent(title: "BDSM를 시도해 보는 건 어때요?", highlight: "BDSM"),
        ChallengeToolbarBannerContent(title: "새로운 체위를 찾아보는 건 어때요?", highlight: "새로운 체위")
    ]
    
    private lazy var sepatator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ChallengeDetailToolbarNameSpace.separatorBackgroundColor)
        
        return view
    }()
    
    private lazy var recommendationLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailToolbarNameSpace.recommendationLabelText
        label.textColor = UIColor(named: ChallengeDetailToolbarNameSpace.recommendationLabelTextColor)
        
        label.font = UIFont(name: ChallengeDetailToolbarNameSpace.recommendationLabelTextFont,
                            size: ChallengeDetailToolbarNameSpace.recommendationLabelTextSize)
        label.backgroundColor = .clear
        label.setLineHeight(height: ChallengeDetailToolbarNameSpace.recommnedationLabelLineHeight)
        label.textAlignment = .center
        label.layer.borderColor = UIColor(named: ChallengeDetailToolbarNameSpace.recommendationLabelBorderColor)?.cgColor
        label.layer.borderWidth = ChallengeDetailToolbarNameSpace.recommendationLabelBorderWidth
        label.layer.cornerRadius = ChallengeDetailToolbarNameSpace.recommendationLabelCorderRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = ChallengeDetailToolbarNameSpace.bannerCollectionViewLineSpacing
        layout.minimumInteritemSpacing = ChallengeDetailToolbarNameSpace.bannerCollectionViewItemSpacing
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(ChallengeDetailToolbarBannerCell.self,
                                forCellWithReuseIdentifier: ChallengeDetailToolbarBannerCellNameSpace.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        switch toolbarType {
        case .title:
            button.setTitle(ChallengeDetailToolbarNameSpace.nextButtonTitleDefaultText, for: .normal)
        case .deadline:
            button.setTitle(ChallengeDetailToolbarNameSpace.nextButtonTitleDefaultText, for: .normal)
        case .content:
            button.setTitle(ChallengeDetailToolbarNameSpace.nextButtonTitleContentTypeText, for: .normal)
        }
        
        button.setTitleColor(UIColor(named: ChallengeDetailToolbarNameSpace.nextButtonTitleTextColor), for: .normal)
        button.titleLabel?.font = UIFont(name: ChallengeDetailToolbarNameSpace.nextButtonTitleTextFont,
                                         size: ChallengeDetailToolbarNameSpace.nextButtonTitleTextSize)
        button.backgroundColor = .clear
        
        return button
    }()
    
    init(type: ChallengeToolbarType) {
        print("toolBar ini")
        self.toolbarType = type
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width,
                                                             height: ChallengeDetailToolbarNameSpace.height)))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let barButtonItem = UIBarButtonItem(customView: nextButton)
        
        items = [space, barButtonItem]
        
        self.setAttributes()
        
        if toolbarType == .title {
            self.addSubComponents()
            self.setConfigurations()
            self.bannerTimer()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        barTintColor = .white
        addSubview(sepatator)
        sepatator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ChallengeDetailToolbarNameSpace.separatorHeight)
        }
    }
    
    private func addSubComponents() {
        addToolbarSubCompnents()
    }
    
    private func setConfigurations() {
        makeRecommnedLabelConstraints()
        makeBannerCollectionViewConstratins()
    }
}

extension ChallengeDetailToolbar {
    private func addToolbarSubCompnents() {
        [recommendationLabel, bannerCollectionView].forEach { addSubview($0) }
    }
    
    private func makeRecommnedLabelConstraints() {
        recommendationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ChallengeDetailToolbarNameSpace.recommendationLabelLeadingInset)
            $0.trailing.equalTo(recommendationLabel.snp.leading).offset(ChallengeDetailToolbarNameSpace.recommendationLabelWidth)
            $0.height.equalTo(ChallengeDetailToolbarNameSpace.recommendationLabelHeight)
        }
    }
    
    private func makeBannerCollectionViewConstratins() {
        bannerCollectionView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recommendationLabel.snp.trailing).offset(ChallengeDetailToolbarNameSpace.bannerCollectionViewLeadingOffset)
            $0.trailing.equalToSuperview().inset(ChallengeDetailToolbarNameSpace.bannerCollectionViewTrailingInset)
            $0.height.equalTo(ChallengeDetailToolbarNameSpace.bannerCollectionViewHeight)
        }
    }
}

extension ChallengeDetailToolbar {
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    
    func bannerMove() {
        currentPage += 1
        bannerCollectionView.scrollToItem(at: NSIndexPath(item: currentPage, section: 0) as IndexPath,
                                          at: .bottom,
                                          animated: true)
        
        if self.currentPage == self.bannerContents.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollToFirstIndex()
            }
        }
    }
    
    func scrollToFirstIndex() {
        bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath,
                                          at: .top, animated: false)
        currentPage = 0
    }
}

extension ChallengeDetailToolbar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.bannerContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailToolbarBannerCellNameSpace.identifier,
                                                            for: indexPath) as? ChallengeDetailToolbarBannerCell else { return UICollectionViewCell() }
        cell.setData(with: bannerContents[indexPath.item])
        
        return cell
    }
}

extension ChallengeDetailToolbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailToolbar_Presentable()
    }
    
    struct ChallengeDetailToolbar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailToolbar(type: .title)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
