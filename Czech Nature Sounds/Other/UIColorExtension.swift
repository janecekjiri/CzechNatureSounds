//
//  UIColorExtension.swift
//  Czech Nature Sounds
//
//  Created by Jiri Janecek on 04.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

import UIKit

extension UIColor {
    static var cellBackgroundColor: UIColor {
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                // 322F2F
                return UIColor(red: 50/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
            } else {
                // F5ECEC
                return UIColor(red: 245/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
            }
        }
    }
}
