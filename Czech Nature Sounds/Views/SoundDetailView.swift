//
//  SoundDetailView.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 11.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import UIKit

final class SoundDetailView: UIView {
    // MARK: - Properties
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let timeLabel = UILabel()
    let slider = UISlider()
    let playButton = UIButton(configuration: .filled())
    let stopButton = UIButton(configuration: .tinted())
    let boldFontAttrStringKey: [NSAttributedString.Key : Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
    
    var onSliderValueChanged: (() -> Void)?
    var onPlayButtonPressed: (() -> Void)?
    var onStopButtonPressed: (() -> Void)?
    
    var playButtonTitle: String? {
        didSet {
            guard let title = self.playButtonTitle else { return }
            
            let attributedString = NSAttributedString(
                string: title,
                attributes: self.boldFontAttrStringKey
            )
            self.playButton.configuration?.attributedTitle = AttributedString(attributedString)
        }
    }
    
    var playButtonImageName: String? {
        didSet {
            guard let name = self.playButtonImageName else { return }
            
            self.playButton.configuration?.image = UIImage(systemName: name)
        }
    }
    
    var playerState: PlayerStateEnum = .notStarted {
        didSet {
            self.slider.isEnabled = self.playerState == .notStarted
            self.stopButton.isEnabled = self.playerState != .notStarted
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func selfInit() {
        self.configureUI()
        self.configureLayout()
    }
    
    private func configureUI() {
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.titleLabel.textColor = .label
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        
        self.descriptionLabel.font = UIFont.italicSystemFont(ofSize: 15)
        self.descriptionLabel.textColor = .label
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.descriptionLabel)
        
        self.timeLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("selected_time_interval", comment: ""),
            30
        )
        self.timeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.timeLabel.textColor = .label
        self.timeLabel.textAlignment = .center
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeLabel)
        
        self.slider.minimumValue = 0
        self.slider.maximumValue = 60
        self.slider.value = 30
        self.slider.addAction(
            UIAction { [weak self] _ in
                self?.onSliderValueChanged?()
            },
            for: .valueChanged
        )
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.slider)
        
        self.playButton.configuration?.imagePlacement = .trailing
        self.playButton.configuration?.imagePadding = 5
        self.playButton.configuration?.cornerStyle = .large
        self.playButton.addAction(
            UIAction { [weak self] _ in
                self?.onPlayButtonPressed?()
            },
            for: .touchUpInside
        )
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.playButton)
        
        let stopAttributedString = NSAttributedString(
            string: NSLocalizedString("stop", comment: "Stop"),
            attributes: self.boldFontAttrStringKey
        )
        self.stopButton.configuration?.attributedTitle = AttributedString(stopAttributedString)
        self.stopButton.configuration?.image = UIImage(systemName: "square.fill")
        self.stopButton.configuration?.imagePlacement = .trailing
        self.stopButton.configuration?.imagePadding = 5
        self.stopButton.configuration?.cornerStyle = .large
        self.stopButton.addAction(
            UIAction { [weak self] _ in
                self?.onStopButtonPressed?()
            },
            for: .touchUpInside
        )
        self.stopButton.isEnabled = false
        self.stopButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stopButton)
    }
    
    private func configureLayout() {
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.timeLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 25).isActive = true
        self.timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.slider.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 15).isActive = true
        self.slider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        self.slider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        self.playButton.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 50).isActive = true
        self.playButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        self.playButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.stopButton.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 50).isActive = true
        self.stopButton.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        self.stopButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
