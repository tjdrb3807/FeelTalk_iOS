//
//  NoteBackgroundView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import UIKit
import SnapKit

final class NoteBackgroundView: UIView {
    private lazy var firstNoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_first_note_background")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
    
        return imageView
    }()
    
    private lazy var secondNoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_second_note_background")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var thirdNoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_third_note_background")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        [firstNoteImageView, secondNoteImageView, thirdNoteImageView].forEach { addSubview($0) }
        
        firstNoteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 7.38)
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 12.80)
            $0.trailing.bottom.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        secondNoteImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 20.60)
            $0.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 9.56)
        }
        
        thirdNoteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 0.41)
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 12.11)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 3.91)
        }
    }
}

#if DEBUG

import SwiftUI

struct NoteBackgroundView_Preview: PreviewProvider {
    static var previews: some View {
        NoteBackgroundView_Presentable()
    }
    
    struct NoteBackgroundView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            NoteBackgroundView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
#endif
