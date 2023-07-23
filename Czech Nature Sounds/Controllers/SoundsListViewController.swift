//
//  SoundsListViewController.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 03.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import UIKit

final class SoundsListViewController: UIViewController {
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let model: SoundsListModel
    private let dataSource: SoundsListDataSource
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selfInit()
    }
    
    // MARK: - Init
    
    init(model: SoundsListModel) {
        self.model = model
        self.dataSource = SoundsListDataSource(soundModels: self.model.soundModels)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func selfInit() {
        self.view.backgroundColor = .systemBackground
        
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        self.tableView.register(SoundCell.self, forCellReuseIdentifier: SoundCell.kCellReuseIdentifier)
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}

extension SoundsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundModel = self.model.soundModels[indexPath.row]
        
        guard let audioPlayer = self.model.makeAudioPlayer(for: soundModel) else {
            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: .default)
            let alertController = UIAlertController(
                title: NSLocalizedString("error_cannot_play_track", comment: ""),
                message: NSLocalizedString("error_cannot_play_track_message", comment: ""),
                preferredStyle: .alert
            )
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        let detailVC = SoundDetailViewController(soundModel: soundModel, audioPlayer: audioPlayer)
        self.present(detailVC, animated: true)
    }
}
