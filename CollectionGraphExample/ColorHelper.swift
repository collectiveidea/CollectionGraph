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

    func colorForSection(section: Int) -> UIColor {

        switch section {
        case 0:
            // blue-ish
            return UIColor(red: 61.0 / 255.0, green: 151.0 / 255.0, blue: 201.0 / 255.0, alpha: 1)
        case 1:
            // pink-ish
            return UIColor(red: 201.0 / 255.0, green: 61.0 / 255.0, blue: 105.0 / 255.0, alpha: 1)
        case 2:
            // purple-ish
            return UIColor(red: 151.0 / 255.0, green: 61.0 / 255.0, blue: 201.0 / 255.0, alpha: 1)
        case 3:
            // green-ish
            return UIColor(red: 61.0 / 255.0, green: 201.0 / 255.0, blue: 134.0 / 255.0, alpha: 1)
        case 4:
            // yellow-ish green
            return UIColor(red: 157.0 / 255.0, green: 201.0 / 255.0, blue: 61.0 / 255.0, alpha: 1)
        default:
            return UIColor.darkGray
        }
    }

}
