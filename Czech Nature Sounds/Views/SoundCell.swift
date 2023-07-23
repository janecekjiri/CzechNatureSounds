//
//  SoundCell.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 03.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import UIKit

final class SoundCell: UITableViewCell {
    static let kCellReuseIdentifier = "SoundCell"
    
    // MARK: - Properties
    
    var sound: SoundModel? {
        didSet {
            self.configureContent()
        }
    }
    
    private let bgView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.backgroundColor = .systemBackground
        self.addSubview(self.bgView)
        self.selectionStyle = .none
        
        self.bgView.backgroundColor = UIColor.cellBackgroundColor
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
        self.bgView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bgView.addSubview(self.iconImageView)
        self.bgView.addSubview(self.titleLabel)
        
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.textColor = .label
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        self.bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.bgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.bgView.leftAnchor, constant: 20).isActive = true
        self.iconImageView.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 30).isActive = true
        self.iconImageView.bottomAnchor.constraint(equalTo: self.bgView.bottomAnchor, constant: -30).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 20).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 20).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.bgView.rightAnchor, constant: -25).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bgView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func configureContent() {
        guard let imageName = self.sound?.imageName, let title = self.sound?.title else { return }
        self.iconImageView.image = UIImage(named: imageName)
        self.titleLabel.text = title
    }

}
