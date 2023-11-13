//
//  ChatRecordingView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

final class ChatRecordingView: UIStackView {
    let mode = PublishRelay<ChatInputMode>()
    let isRecord = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    private var audioRecoder = AVAudioRecorder()
    private var audioPlayer = AVAudioPlayer()
    
    private lazy var recordURL: URL = {
        var documentsURL: URL = {
            let pahts = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            return pahts.first!
        }()
        
        let fileName = UUID().uuidString + ".m4a"
        let url = documentsURL.appendingPathComponent(fileName)
        
        return url
    }()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "icon_recording_play_white"), for: .normal)
        
        return button
    }()
    
    private lazy var recordingEqualizerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = ChatRecordingViewNameSpace.equlizerViewSpacing
        stackView.backgroundColor = .clear
        
        for _ in ChatRecordingViewNameSpace.equlizerBarZeroCount..<ChatRecordingViewNameSpace.recordingEqulizerBarCount {
            let bar = ChatRecordingEqualizerBar()
            stackView.addArrangedSubview(bar)
            bar.snp.makeConstraints {
                $0.width.equalTo(ChatRecordingEqulizerBarNameSpace.width)
                $0.height.equalTo(ChatRecordingEqulizerBarNameSpace.defaultHeight)
            }
        }
        
        return stackView
    }()
    
    private lazy var playEqulizerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = ChatRecordingViewNameSpace.equlizerViewSpacing
        stackView.backgroundColor = .clear
        
        for _ in ChatRecordingViewNameSpace.equlizerBarZeroCount..<ChatRecordingViewNameSpace.playEqulizerBarCount {
            let bar = ChatRecordingEqualizerBar()
            stackView.addArrangedSubview(bar)
            bar.snp.makeConstraints {
                $0.width.equalTo(ChatRecordingEqulizerBarNameSpace.width)
                $0.height.equalTo(ChatRecordingEqulizerBarNameSpace.defaultHeight)
            }
        }
        
        return stackView
    }()
    
    private lazy var middleSpacing: UIView = { UIView() }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont(name: CommonFontNameSpace.pretendardSemiBold,
                            size: ChatRecordingViewNameSpace.timeLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        mode
            .withUnretained(self)
            .bind { v, mode in
                v.switchContent(with: mode)
            }.disposed(by: disposeBag)
        
        // 녹음 시작
        isRecord
            .filter { $0 }
            .withUnretained(self)
            .bind { v, _ in
                print("녹음 시작")
                v.record()
                Observable<Int>
                    .interval(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                    .compactMap { _ in v.audioRecoder.currentTime }
                    .bind {
                        v.updateTimeLabel(v.convertNSTimeInterval12String($0))
                        v.updateEqulizerBar(v.convertdBFS())
                    }.disposed(by: v.disposeBag)
            }.disposed(by: disposeBag)
        
        // 녹음 중지
        isRecord
            .filter { !$0 }
            .withUnretained(self)
            .bind { v, _ in
                print("녹음 중지")
                v.stop()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = ChatRecordingViewNameSpace.spacing
        backgroundColor = UIColor(named: CommonColorNameSpace.main500)
    }
    
    private func addSubComponents() {
        addRecorndingViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeContentStackViewConstraints()
        makeLeadingSpacingConstraints()
        makeRecordingEqulizerViewConstratins()
        makeMiddleSpacingConstraints()
        makeTrailingSpacingConstraints()
    }
}

extension ChatRecordingView {
    private func addRecorndingViewSubComponents() {
        [topSpacing, contentStackView, bottomSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func makeContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { $0.height.equalTo(ChatRecordingViewNameSpace.contentStackViewHeight) }
    }
    
    private func addContentStackViewSubComponents() {
        [leadingSpacing, recordingEqualizerView, middleSpacing, timeLabel, trailingSpacing].forEach { contentStackView.addArrangedSubview($0) }
        
        [middleSpacing, timeLabel, trailingSpacing].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeLeadingSpacingConstraints() {
        leadingSpacing.snp.makeConstraints { $0.width.equalTo(ChatRecordingViewNameSpace.leadingSpacingWidth) }
    }
    
    private func makePlayButtonConstraints() {
        playButton.snp.makeConstraints { $0.width.equalTo(ChatRecordingViewNameSpace.playButtonWidth) }
    }
    
    private func makeRecordingEqulizerViewConstratins() {
        recordingEqualizerView.snp.makeConstraints { $0.width.equalTo(CommonConstraintNameSpace.horizontalRatioCalculaotr * 52.26) }
    }
    
    private func makePlayEqulizerViewConstraints() {
        playEqulizerView.snp.makeConstraints { $0.width.equalTo(CommonConstraintNameSpace.horizontalRatioCalculaotr * 45.86) }
    }
    
    private func makeMiddleSpacingConstraints() {
        middleSpacing.snp.makeConstraints { $0.width.equalTo(ChatRecordingViewNameSpace.middleSpacingWidth) }
    }
    
    private func makeTrailingSpacingConstraints() {
        trailingSpacing.snp.makeConstraints { $0.width.equalTo(ChatRecordingViewNameSpace.trailingSpacingWidth).priority(.high) }
    }
}

extension ChatRecordingView {
    private func switchContent(with mode: ChatInputMode) {
        let firstSubView = contentStackView.arrangedSubviews[ChatRecordingViewNameSpace.contentStackViewFirstSubViewIndex]
        let secondSubview = contentStackView.arrangedSubviews[ChatRecordingViewNameSpace.contentStackViewSecondSubViewIndex]
        
        contentStackView.removeArrangedSubview(firstSubView)
        contentStackView.removeArrangedSubview(secondSubview)
        
        firstSubView.removeFromSuperview()
        secondSubview.removeFromSuperview()
        
        if mode == .recorded {
            contentStackView.insertArrangedSubview(playButton, at: ChatRecordingViewNameSpace.contentStackViewFirstSubViewIndex)
            contentStackView.insertArrangedSubview(playEqulizerView, at: ChatRecordingViewNameSpace.contentStackViewSecondSubViewIndex)
            
            makeRecordingEqulizerViewConstratins()
            makePlayButtonConstraints()
        } else if mode == .inputMessage {
            contentStackView.insertArrangedSubview(leadingSpacing, at: ChatRecordingViewNameSpace.contentStackViewFirstSubViewIndex)
            contentStackView.insertArrangedSubview(recordingEqualizerView, at: ChatRecordingViewNameSpace.contentStackViewSecondSubViewIndex)
            
            makePlayButtonConstraints()
            makeLeadingSpacingConstraints()
        }
    }
    
    private func updateEqulizerBar(_ dBFS: Int) {
        print(dBFS)
        let firstEqulizerBar = recordingEqualizerView.arrangedSubviews[0] as! ChatRecordingEqualizerBar
        
        if dBFS < -48 {
            firstEqulizerBar.height.accept(CommonConstraintNameSpace.verticalRatioCalculator * 0.98)
        } else if dBFS < -30 {
            firstEqulizerBar.height.accept(CommonConstraintNameSpace.verticalRatioCalculator * 1.47)
        } else if dBFS < -10 {
            firstEqulizerBar.height.accept(CommonConstraintNameSpace.verticalRatioCalculator * 2.09)
        } else {
            firstEqulizerBar.height.accept(CommonConstraintNameSpace.verticalRatioCalculator * 2.91)
        }
    }
    
    private func updateTimeLabel(_ time: String) {
        timeLabel.rx.text.onNext(time)
        timeLabel.snp.remakeConstraints { $0.width.equalTo(timeLabel.intrinsicContentSize) }
    }
}

extension ChatRecordingView {
    private func record() {
        let fileName = UUID().uuidString + ".m4a"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(fileName)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            audioRecoder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecoder.isMeteringEnabled = true
            audioRecoder.delegate = self
            audioRecoder.record()
        } catch {
            print("occured error in MyAudioRecoderView = \(error.localizedDescription)")
            stop()
        }
    }
    
    private func stop() {
        audioRecoder.stop()
    }
    
    private func convertNSTimeInterval12String(_ time: TimeInterval) -> String {
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        
        return strTime
    }
    
    private func convertdBFS() -> Int {
        audioRecoder.updateMeters()
        let dBFS = audioRecoder.averagePower(forChannel: 0)
        
        return Int(dBFS)
    }
}

extension ChatRecordingView: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stop()
    }
}

#if DEBUG

import SwiftUI

struct ChatRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRecordingView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: ChatRecordingViewNameSpace.width,
                   height: ChatRecordingViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChatRecordingView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = ChatRecordingView()
            view.mode.accept(.recorded)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
