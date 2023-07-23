//
//  SoundModel.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 03.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import Foundation

/// Model reprezentující zvuk
struct SoundModel: Decodable {
    /// Název
    public var title: String?
    /// Stručný popis
    public var subtitle: String?
    /// Název obrázku
    public var imageName: String?
    /// Název zvukového souboru
    public var soundFileName: String?
    
    enum CodingKeys: CodingKey {
        case title
        case subtitle
        case imageName
        case soundFileName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        self.soundFileName = try container.decodeIfPresent(String.self, forKey: .soundFileName)
        
        guard let title, let subtitle else { return }
        self.title = NSLocalizedString(title, comment: "")
        self.subtitle = NSLocalizedString(subtitle, comment: "")
    }
}
