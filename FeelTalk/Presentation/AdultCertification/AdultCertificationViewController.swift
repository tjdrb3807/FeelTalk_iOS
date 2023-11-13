//
//  AdultCertificationViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultCertificationViewController: UIViewController {
    private lazy var navigationBar: SignUpFlowNavigationBar = { SignUpFlowNavigationBar(viewType: .signUp) }()
    
    private lazy var progressBar: CustomProgressBar = { CustomProgressBar(persentage: (1/3)) }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     서비스 이용을 위해
                     인증 정보를 입력해 주세요.
                     """
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 24.0)
        label.setLineHeight(height: 36.0)
        label.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProperites()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func setProperites() {
        view.backgroundColor = .white
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeNavigationBarConstraints()
        makePrograssBarConstraints()
//        makeDescriptionLabelConstraints()
//        makeContentStackViewConstraints()
    }
}

extension AdultCertificationViewController {
    private func addViewSubComponents() {
        [navigationBar, progressBar, descriptionLabel, contentStackView].forEach { view.addSubview($0) }
    }
    
    private func makeNavigationBarConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SignUpFlowNavigationBarNameSpace.navigationBarHeight)
        }
    }
    
    private func makePrograssBarConstraints() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CustomProgressBarNameSpace.progressBarHeight)
        }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(92)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
        }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(26.0)
            $0.leading.equalToSuperview().inset(CommonConstraintNameSpace.leadingInset)
            $0.trailing.equalToSuperview().inset(CommonConstraintNameSpace.trailingInset)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultCertificationViewController_Previews: PreviewProvider {
    static var previews: some View {
        AdultCertificationViewController_Presentable()
            .edgesIgnoringSafeArea(.top)
    }
    
    struct AdultCertificationViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            AdultCertificationViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
