//
//  SoundDetailModel.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 08.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import AVFoundation
import Foundation
import MediaPlayer

extension Notification.Name {
    static let PlayerStateChanged = Self("PlayerStateChanged")
    static let SelectedTimeChanged = Self("SelectedTimeChanged")
    static let RemainingTimeChanged = Self("RemainingTimeChanged")
}

enum PlayerStateEnum {
    /// Přehrávání nezačalo. Reprezentuje i stav, kdy čas uplyne a přehrávání skončí
    case notStarted
    case playing
    case paused
    case resumed
    
    var buttonTitle: String {
        switch self {
        case .notStarted:
            return NSLocalizedString("play", comment: "Play")
        case .playing, .resumed:
            return NSLocalizedString("pause", comment: "Pause")
        case .paused:
            return NSLocalizedString("continue", comment: "Continue")
        }
    }
    
    var buttonImageName: String {
        switch self {
        case .notStarted, .paused:
            return "play.fill"
        case .playing, .resumed:
            return "pause.fill"
        }
    }
}

final class SoundDetailModel: NSObject {
    // MARK: - Properties
    
    // MARK: Public
    
    let soundModel: SoundModel
    
    var playButtonTitle: String {
        self.playerState.buttonTitle
    }
    
    var playButtonImageName: String {
        self.playerState.buttonImageName
    }
    
    private(set) var timer: Timer?
    
    /// Stav přehrávače
    private(set) var playerState: PlayerStateEnum = .notStarted {
        didSet {
            switch self.playerState {
            case .notStarted:
                self.audioPlayer.currentTime = 0
                self.audioPlayer.stop()
                self.setSelectedTime(Float(self.selectedTime))
                if self.timer != nil {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            case .playing:
                self.audioPlayer.play()
            case .paused:
                self.audioPlayer.pause()
            case .resumed:
                self.audioPlayer.play()
            }
            
            NotificationCenter.default.post(name: .PlayerStateChanged, object: nil, userInfo: [
                "isStoppedByUser": self.isStoppedByUser
            ])
            self.isStoppedByUser = false
        }
    }
    
    /// Zvolená doba přehrávání
    private(set) var selectedTime: Int = 30 {
        didSet {
            NotificationCenter.default.post(name: .SelectedTimeChanged, object: nil)
        }
    }
    
    private(set) var isStoppedByUser = false
    
    // MARK: Private
    
    private let audioPlayer: AVAudioPlayer
    
    private var selectedTimeInSeconds = 0 {
        didSet {
            let minutes = self.selectedTimeInSeconds / 60
            let seconds = self.selectedTimeInSeconds - (minutes * 60)
            let secondsText = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            self.remainingTimeText = "\(minutes):\(secondsText)"
            NotificationCenter.default.post(
                name: .RemainingTimeChanged,
                object: nil,
                userInfo: [
                    "time": "\(minutes):\(secondsText)"
                ]
            )
        }
    }
    
    private var remainingTimeText: String?
    
    // MARK: - Init
    
    init(soundModel: SoundModel, audioPlayer: AVAudioPlayer) {
        self.soundModel = soundModel
        self.audioPlayer = audioPlayer
        super.init()
        self.audioPlayer.numberOfLoops = -1
        self.registerNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    // MARK: - Methods
    
    // MARK: Public
    
    func setSelectedTime(_ value: Float) {
        let increment: Float = 5
        let roundedValue = round(value / increment) * increment
        self.selectedTime = Int(roundedValue)
    }
    
    func play() {
        guard self.playerState == .notStarted else { return }
        self.playerState = .playing
        self.selectedTimeInSeconds = self.selectedTime * 60
        self.configureTimer()
        self.setNowPlayingInfoCenter()
    }
    
    func pause() {
        guard self.playerState == .playing || self.playerState == .resumed else { return }
        self.playerState = .paused
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func resume() {
        guard self.playerState == .paused else { return }
        self.playerState = .resumed
        self.configureTimer()
    }
    
    func stop(isStoppedByUser: Bool) {
        guard self.playerState == .playing || self.playerState == .resumed else { return }
        self.isStoppedByUser = isStoppedByUser
        self.playerState = .notStarted
        self.cleanNowPlayingInfoCenter()
    }
    
    // MARK: Private
    
    private func setNowPlayingInfoCenter() {
        var nowPlayingInfo = [String: Any]()
        
        if let title = self.soundModel.title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        
        if let remainingTimeText {
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = remainingTimeText
        }
        
        if let imageName = self.soundModel.imageName, let image = UIImage(named: imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func cleanNowPlayingInfoCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func configureTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self, self.selectedTimeInSeconds != 0 else {
                self?.stop(isStoppedByUser: false)
                return
            }
            self.selectedTimeInSeconds -= 1
            self.setNowPlayingInfoCenter()
        })
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleInterruption(notification:)),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }
    
    @objc
    private func handleInterruption(notification: Notification) {
        guard
            self.playerState != .notStarted,
            let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }
        
        switch type {
        case .began:
            self.pause()
        case .ended:
            self.resume()
        default: ()
        }
    }
}
