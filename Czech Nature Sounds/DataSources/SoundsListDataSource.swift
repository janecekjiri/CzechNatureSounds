//
//  SoundsListDataSource.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 11.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import UIKit

final class SoundsListDataSource: NSObject, UITableViewDataSource {
    let soundModels: [SoundModel]
    
    init(soundModels: [SoundModel]) {
        self.soundModels = soundModels
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.soundModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SoundCell.kCellReuseIdentifier, for: indexPath) as? SoundCell {
            cell.sound = self.soundModels[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
