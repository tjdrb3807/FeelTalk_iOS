//
//  OnboardingViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    typealias OnboardingTitle = (String, String)
    
    var viewModel: OnboardingViewModel!
    private let disposeBag = DisposeBag()
    
    private let titles = [OnboardingTitle(OnboardingTitleViewNameSpace.titleLabelFirstText,
                                          OnboardingTitleViewNameSpace.descriptionLabelFirstText),
                          OnboardingTitle(OnboardingTitleViewNameSpace.titleLabelSecondText,
                                          OnboardingTitleViewNameSpace.descriptionLabelSecondText),
                          OnboardingTitle(OnboardingTitleViewNameSpace.titleLabelThirdText,
                                          OnboardingTitleViewNameSpace.descriptionLabelThirdText)]
    private let images = [UIImage(named: OnboardingViewNameSpace.firstImage),
                          UIImage(named: OnboardingViewNameSpace.secondImage),
                          UIImage(named: OnboardingViewNameSpace.thirdImage)]
    
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: OnboardingViewNameSpace.logoImage)
        
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
        pageControl.currentPageIndicatorTintColor = UIColor(named: CommonColorNameSpace.main500)
        pageControl.pageIndicatorTintColor = UIColor(named: CommonColorNameSpace.gray300)
        
        return pageControl
    }()
    
    private lazy var firstTitleView: OnboardingTitleView = {
        let view = OnboardingTitleView(title: titles[0].0, description: titles[0].1)
        view.alpha = 1.0
        
        return view
    }()
    
    private lazy var secondTitleView: OnboardingTitleView = {
        let view = OnboardingTitleView(title: titles[1].0, description: titles[1].1)
        view.alpha = 0.0
        
        return view
    }()
    
    private lazy var thirdTitleView: OnboardingTitleView = {
        let view = OnboardingTitleView(title: titles[2].0, description: titles[2].1)
        view.alpha = 0.0
        
        return view
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle(OnboardingViewNameSpace.startButtonTitleText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                         size: OnboardingViewNameSpace.startButtonTitleTextSize)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = OnboardingViewNameSpace.startButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var inquiryButton: CustomBottomBorderButton = { CustomBottomBorderButton(title: OnboardingViewNameSpace.inquiryButtonTitleText) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
        self.setupScrollView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    private func bind(to viewModel: OnboardingViewModel) {
        let input = OnboardingViewModel.Input(tapStartButton: startButton.rx.tap.asObservable(),
                                              tapInquiryButton: inquiryButton.rx.tap.asObservable())
        
        let _ = viewModel.transfer(input: input)
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeLogoConstraints()
        makePageControlConstraints()
        makeTitleViewConstraints()
        makeImageScrollViewConstraints()
        makeStartButtonConstraints()
        makeInquiryButtonConstraints()
    }
}

extension OnboardingViewController {
    private func addViewSubComponents() {
        [logo, pageControl,
         firstTitleView, secondTitleView, thirdTitleView,
         imageScrollView, startButton, inquiryButton].forEach { view.addSubview($0) }
    }
    
    private func makeLogoConstraints() {
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingViewNameSpace.logoTopOffset)
        }
    }
    
    private func makePageControlConstraints() {
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(OnboardingViewNameSpace.pageControlTopOffset)
            $0.height.equalTo(OnboardingViewNameSpace.pageControlHeight)
        }
    }
    
    private func makeTitleViewConstraints() {
        [firstTitleView, secondTitleView, thirdTitleView]
            .forEach { $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingTitleViewNameSpace.topOffset)
            }}
    }
    
    private func makeImageScrollViewConstraints() {
        imageScrollView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingViewNameSpace.imageScrollViewTopOffset)
            $0.width.equalToSuperview()
            $0.height.equalTo(OnboardingViewNameSpace.imageScrollViewHeight)
        }
    }
    
    private func makeStartButtonConstraints() {
        startButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
            $0.bottom.equalToSuperview().inset(OnboardingViewNameSpace.startButtonBottomInset)
            $0.height.equalTo(OnboardingViewNameSpace.startButtonHeight)
        }
    }
    
    private func makeInquiryButtonConstraints() {
        inquiryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(startButton.snp.bottom).offset(OnboardingViewNameSpace.inquiryButtonTopOffset)
            $0.height.equalTo(OnboardingViewNameSpace.inquiryButtonHeight)
        }
    }
}

extension OnboardingViewController {
    private func setTitleView(with offsetX: CGFloat) {
        let alpha: CGFloat = 1.0 - (offsetX / UIScreen.main.bounds.width)
        
        if alpha <= 1.0 &&  alpha >= 0.0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.firstTitleView.alpha = alpha
                self.secondTitleView.alpha = 1.0 - alpha
            }
        } else {
            let alpha = 1.0 + alpha

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.secondTitleView.alpha = alpha
                self.thirdTitleView.alpha = 1.0 - alpha
            }
        }
    }
    
    private func setupScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let positionX = self.view.frame.width * CGFloat(i)
            
            imageView.frame = CGRect(x: positionX,
                                     y: 0.0,
                                     width: UIScreen.main.bounds.width,
                                     height: OnboardingViewNameSpace.imageScrollViewHeight)
            imageView.image = images[i]
            imageScrollView.addSubview(imageView)
            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
    func selectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = imageScrollView.contentOffset.x / imageScrollView.frame.size.width
        
        selectedPage(currentPage: Int(round(size)))
        
        let offsetX = scrollView.contentOffset.x
        
        guard offsetX >= 0 && offsetX <= UIScreen.main.bounds.width * 2 else { return }
        setTitleView(with: offsetX)
    }
}

#if DEBUG

import SwiftUI

struct OnboardingViewController_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct OnboardingViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vc = OnboardingViewController()
            let vm = OnboardingViewModel(coordinator: DefaultOnboardingCoordinator(UINavigationController()))
            
            vc.viewModel = vm
            
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
