//
//  PasswordViewController.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct KeypadModel {
    let title: String
}

final class PasswordViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let keypadModels: [KeypadModel] = {[
        KeypadModel(title: "1"),
        KeypadModel(title: "4"),
        KeypadModel(title: "7"),
        KeypadModel(title: "취소"),
        KeypadModel(title: "2"),
        KeypadModel(title: "5"),
        KeypadModel(title: "8"),
        KeypadModel(title: "0"),
        KeypadModel(title: "3"),
        KeypadModel(title: "6"),
        KeypadModel(title: "9"),
        KeypadModel(title: "확인"),]
    }()
    
    private lazy var passwordDisplayView: PasswordDisplayView = { PasswordDisplayView() }()
    
    private lazy var keypad: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PasswordKeypadCell.self, forCellWithReuseIdentifier: "KeypadCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    private func bind() {
        
    }
    
    private func setConfigurations() { view.backgroundColor = .white }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makePasswordDisplayViewConstraints()
        makeKeypadConstraints()
    }
}

extension PasswordViewController {
    private func addViewSubComponents() {
        [passwordDisplayView, keypad].forEach { view.addSubview($0) }
    }
    
    private func makePasswordDisplayViewConstraints() {
        passwordDisplayView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(204)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeKeypadConstraints() {
        keypad.snp.makeConstraints {
            $0.top.equalTo(keypad.snp.bottom).offset(-280)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension PasswordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keypadModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeypadCell", for: indexPath) as? PasswordKeypadCell else { return UICollectionViewCell() }
        
        cell.model.accept(keypadModels[indexPath.row])
        
        return cell
    }
}

extension PasswordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width / 3,
               height: 70)
    }
}

#if DEBUG

import SwiftUI

struct PasswordViewController_Previews: PreviewProvider {
    static var previews: some View {
        PasswordViewController_Presentable()
    }
    
    struct PasswordViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            PasswordViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
