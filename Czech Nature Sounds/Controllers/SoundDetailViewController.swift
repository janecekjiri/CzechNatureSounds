//
//  SoundDetailViewController.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 04.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import AVFoundation
import MediaPlayer
import UIKit

final class SoundDetailViewController: UIViewController {
    // MARK: - Properties
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private let detailView = SoundDetailView()
    
    private let model: SoundDetailModel
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selfInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.model.stop(isStoppedByUser: false)
    }
    
    // MARK: - Init
    
    init(soundModel: SoundModel, audioPlayer: AVAudioPlayer) {
        self.model = .init(soundModel: soundModel, audioPlayer: audioPlayer)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .PlayerStateChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .SelectedTimeChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .RemainingTimeChanged, object: nil)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    // MARK: - Methods
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event, event.type == .remoteControl else { return }
        
        switch event.subtype {
        case .remoteControlPlay:
            self.model.resume()
        case .remoteControlPause:
            self.model.pause()
        case .remoteControlStop:
            self.model.stop(isStoppedByUser: true)
        default:
            break
        }
    }
    
    private func selfInit() {
        self.configureUI()
        self.configureLayout()
        self.registerNotifications()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        if let sheet = self.sheetPresentationController {
            sheet.preferredCornerRadius = 20
            sheet.detents = self.setDetends()
        }
        
        self.detailView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.detailView)
        
        self.detailView.titleLabel.text = self.model.soundModel.title
        self.detailView.descriptionLabel.text = self.model.soundModel.subtitle
        self.detailView.playButtonTitle = self.model.playButtonTitle
        self.detailView.playButtonImageName = self.model.playButtonImageName
        
        self.detailView.onSliderValueChanged = { [weak self] in
            self?.onSliderValueChanged()
        }
        
        self.detailView.onPlayButtonPressed = { [weak self] in
            self?.onPlayButtonPressed()
        }
        
        self.detailView.onStopButtonPressed = { [weak self] in
            self?.onStopButtonPressed()
        }
        
        // Voláme z toho důvodu, aby při prvním spuštění se zvolený čas uložil do modelu
        self.model.setSelectedTime(30)
    }
    
    private func configureLayout() {
        self.detailView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.detailView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.detailView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setDetends() -> [UISheetPresentationController.Detent] {
        if #available (iOS 16.0, *) {
            return [
                .custom { _ in
                    return 300
                }
            ]
        } else {
            return [.medium()]
        }
    }
    
    private func onSliderValueChanged() {
        self.model.setSelectedTime(self.detailView.slider.value)
    }
    
    private func onPlayButtonPressed() {
        switch self.model.playerState {
        case .notStarted:
            self.model.play()
        case .playing, .resumed:
            // Jelikož se teď hraje, přehrávanou hudbu pauzneme
            self.model.pause()
        case .paused:
            self.model.resume()
        }
    }
    
    private func onStopButtonPressed() {
        self.model.stop(isStoppedByUser: true)
    }
    
    // MARK: Notifikace
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPlayerStateChanged(_:)), name: .PlayerStateChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSelectedTimeChanged), name: .SelectedTimeChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onRemainingTimeChanged(_:)), name: .RemainingTimeChanged, object: nil)
    }
    
    @objc
    private func onPlayerStateChanged(_ notification: Notification) {
        self.detailView.playButtonTitle = self.model.playButtonTitle
        self.detailView.playButtonImageName = self.model.playButtonImageName
        self.detailView.playerState = self.model.playerState
        
        if self.model.playerState == .notStarted, let isStoppedByUser = notification.userInfo?["isStoppedByUser"] as? Bool, !isStoppedByUser {
            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: .default)
            let alertController = UIAlertController(title: NSLocalizedString("track_finished_playing", comment: ""), message: nil, preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    @objc
    private func onSelectedTimeChanged() {
        self.detailView.slider.value = Float(self.model.selectedTime)
        self.detailView.timeLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("selected_time_interval", comment: ""),
            self.model.selectedTime
        )
        self.detailView.playButton.isEnabled = self.model.selectedTime != 0
    }
    
    @objc
    private func onRemainingTimeChanged(_ notification: Notification) {
        guard let time = notification.userInfo?["time"] as? String else { return }
        self.detailView.timeLabel.text = time
    }
}
