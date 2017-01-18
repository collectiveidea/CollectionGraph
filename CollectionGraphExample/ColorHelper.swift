//
//  ColorHelper.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/13/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit

protocol ColorHelpers {
    func colorForSection(section: Int) -> UIColor
}

extension ColorHelpers {

    // http://www.colorhunt.co/c/43813

    func colorForSection(section: Int) -> UIColor {

        switch section {
        case 0:
            // blue
            return UIColor(red: 69.0 / 255.0, green: 193.0 / 255.0, blue: 201.0 / 255.0, alpha: 1)
        case 1:
            // pink
            return UIColor(red: 252.0 / 255.0, green: 81.0 / 255.0, blue: 133.0 / 255.0, alpha: 1)
        case 2:
            // yellow
            return UIColor(red: 252.0 / 255.0, green: 227.0 / 255.0, blue: 138.0 / 255.0, alpha: 1)
        case 3:
            // purple
            return UIColor(red: 187.0 / 255.0, green: 88.0 / 255.0, blue: 176.0 / 255.0, alpha: 1)
        case 4:
            // grey
            return UIColor(red: 125.0 / 255.0, green: 124.0 / 255.0, blue: 122.0 / 255.0, alpha: 1)
        default:
            return UIColor.darkGray
        }
    }

}
