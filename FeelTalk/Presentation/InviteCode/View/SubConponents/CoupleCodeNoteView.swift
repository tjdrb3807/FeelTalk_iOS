//
//  CoupleCodeNoteView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit

final class CoupleCodeNoteView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = InviteCodeNameSpace.inviteCodeNoteViewTotalVerticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = InviteCodeNameSpace.inviteCodeNoteViewTitleLabelText
        label.font = UIFont(name: InviteCodeNameSpace.inviteCodeNoteViewTitleLabelTextFont,
                            size: InviteCodeNameSpace.inviteCodeNoteViewTitleLabelTextSize)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var coupleCodeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var coupleCodeViewVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.23
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var coupleCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "FPFK41E"
        label.font = UIFont(name: "pretendard-medium", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var coupleCodeCopyButton: UIButton = {
        let button = UIButton()
        button.setTitle("코드복사", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "pretendard-regular", size: 16.0)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 4.92) / 2
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private lazy var refreshView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var refreshViewHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.6
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var coupleCodeRefreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_refresh"), for: .normal)
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.44) / 2
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var coupleCodeRefreshLabel: UILabel = {
        let label = UILabel()
        label.text = "새로고침"
        label.font = UIFont(name: "pretendard-regular", size: 14.0)
        label.textColor = UIColor(named: "main_300")
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_refresh"), for: .normal)
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 3.44) / 2
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var refreshLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        self.backgroundColor = UIColor(named: "main_500")
        self.layer.cornerRadius = 12.0
    }
    
    private func setConfig() {
        [coupleCodeLabel, coupleCodeCopyButton].forEach { coupleCodeViewVerticalStackView.addArrangedSubview($0) }

        coupleCodeCopyButton.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 21.06)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.92)
        }
        
        coupleCodeView.addSubview(coupleCodeViewVerticalStackView)
        
        coupleCodeViewVerticalStackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        [coupleCodeRefreshButton, coupleCodeRefreshLabel].forEach { refreshViewHorizontalStackView.addArrangedSubview($0) }
        
        coupleCodeRefreshButton.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 7.46)
            $0.height.equalTo(coupleCodeRefreshButton.snp.width)
        }
        
        coupleCodeRefreshLabel.snp.makeConstraints { $0.width.equalTo((UIScreen.main.bounds.width / 100) * 12.8) }
        
        refreshView.addSubview(refreshViewHorizontalStackView)
        
        refreshViewHorizontalStackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        [titleLabel, coupleCodeView, refreshView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 2.58) }

        coupleCodeView.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 30.54) }

        refreshView.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.44) }

        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 2.46)
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 8.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct CoupleCodeNoteView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleCodeNoteView_Presentable()
    }
    
    struct CoupleCodeNoteView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CoupleCodeNoteView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
