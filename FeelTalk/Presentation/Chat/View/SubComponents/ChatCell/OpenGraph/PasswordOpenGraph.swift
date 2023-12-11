//
//  PasswordOpenGraph.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordOpenGraop: UIView {
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.backgroundColor = .yellow.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_password_open_graph")
        
        return imageView
    }()
    
    private lazy var contentStakcView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        stackView.backgroundColor = .red.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     연인이 새 암호를
                     설정할 수 있도록 도와주세요
                     """
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: 16.0)
        label.setLineHeight(height: 24.0)
        label.textAlignment = .center
        label.backgroundColor = .blue.withAlphaComponent(0.4)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     연인이 암호를 잃어버렸어요. 도와주기 버튼을
                     누르면 연인이 암호를 재설정할 수 있어요.
                     """
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.numberOfLines = 0
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.4)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        stackView.backgroundColor = .blue.withAlphaComponent(0.4)
        
        return stackView
    }()
    
    private lazy var warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_warning_open_graph")
        imageView.backgroundColor = .white.withAlphaComponent(0.4)
        
        return imageView
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "수락 전, 해킹에 유의해 주세요 !"
        label.textColor = .red
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: 12.0)
        label.setLineHeight(height: 18.0)
        label.backgroundColor = .white.withAlphaComponent(0.4)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("도와주기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                         size: 16.0)
        button.backgroundColor = UIColor(named: CommonColorNameSpace.main500)
        button.layer.cornerRadius = 40 / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setProperties() {
        backgroundColor = UIColor(named: CommonColorNameSpace.gray100)
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTotalStackViewSubComponents()
        addContentStackViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeTotalStackViewConstraints()
        makeTitleImageViewConstraints()
        makeHelpButtonConstraints()
    }
}

extension PasswordOpenGraop {
    private func addViewSubComponents() { addSubview(totalStackView) }
    
    private func makeTotalStackViewConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalToSuperview().inset(12.0)
        }
    }
    
    private func addTotalStackViewSubComponents() {
        [titleImageView, contentStakcView, labelStackView, helpButton].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeTitleImageViewConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(130.0)
            $0.height.equalTo(130.0)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [titleLabel, descriptionLabel].forEach { contentStakcView.addArrangedSubview($0) }
    }
    
    private func addLabelStackViewSubComponents() {
        [warningImageView, warningLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func makeHelpButtonConstraints() {
        helpButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(40.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct PasswordOpenGraop_Previews: PreviewProvider {
    static var previews: some View {
        PasswordOpenGraop_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 250,
                   height: 344,
                   alignment: .center)
    }
    
    struct PasswordOpenGraop_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PasswordOpenGraop()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
