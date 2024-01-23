//
//  EmptyChallengeView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/20.
//

import UIKit
import SnapKit

final class EmptyChallengeView: UIStackView {
    private lazy var imageView: UIImageView = { UIImageView(image: UIImage(named: EmptyChallengeViewNameSpace.image)) }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = EmptyChallengeViewNameSpace.labelStackViewSpacing
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: CommonColorNameSpace.gray600)
        label.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                            size: EmptyChallengeViewNameSpace.headerLabelTextSize)
        label.setLineHeight(height: EmptyChallengeViewNameSpace.headerLabelLineHeight)
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = EmptyChallengeViewNameSpace.bodyLabelText
        label.textColor = UIColor(named: CommonColorNameSpace.gray500)
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: EmptyChallengeViewNameSpace.bodyLabelTextSize)
        label.setLineHeight(height: EmptyChallengeViewNameSpace.bodyLabelLineHeihgt)
        label.numberOfLines = EmptyChallengeViewNameSpace.bodyLabelNumberOfLines
        label.textAlignment = .center
        
        return label
    }()
    
    init(state: ChallengeState) {
        super.init(frame: .zero)
        
        state == .ongoing ? (headerLabel.text = EmptyChallengeViewNameSpace.headerLabelOngoingStateText) : (headerLabel.text = EmptyChallengeViewNameSpace.headerLabelCompletedStateText)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = EmptyChallengeViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addLabelStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeImageViewConstraints()
    }
}

extension EmptyChallengeView {
    private func addViewSubComponents() {
        [imageView, labelStackView].forEach { addArrangedSubview($0) }
    }
    
    private func makeImageViewConstraints() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(EmptyChallengeViewNameSpace.imageWidth)
            $0.height.equalTo(EmptyChallengeViewNameSpace.imageHeight)
        }
    }
    
    private func addLabelStackViewSubComponents() {
        [headerLabel, bodyLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
}

#if DEBUG

import SwiftUI

struct EmptyChallengeView_Previewvews: PreviewProvider {
    static var previews: some View {
        EmptyChallengeView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: EmptyChallengeViewNameSpace.width,
                   height: EmptyChallengeViewNameSpace.height,
                   alignment: .center)
    }
    
    struct EmptyChallengeView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            EmptyChallengeView(state: .completed)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
