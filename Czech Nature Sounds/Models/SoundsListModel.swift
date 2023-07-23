//
//  SoundsListModel.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 03.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import AVFoundation
import Foundation

final class SoundsListModel: NSObject {
    private(set) var soundModels: [SoundModel] = []
    
    override init() {
        super.init()
        
        self.decodeSoundModels()
    }
    
    func makeAudioPlayer(for soundModel: SoundModel) -> AVAudioPlayer? {
        guard
            let soundFileName = soundModel.soundFileName,
            let url = Bundle.main.url(forResource: soundFileName, withExtension: "mp3"),
            let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        else {
            return nil
        }
        
        return audioPlayer
    }
    
    private func decodeSoundModels() {
        if let url = Bundle.main.url(forResource: "sounds", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let sounds = try JSONDecoder().decode([SoundModel].self, from: data)
                self.soundModels = sounds
            } catch {
                assertionFailure(NSLocalizedString("error_failed_to_decode_sounds", comment: ""))
            }
        }
    }
}
