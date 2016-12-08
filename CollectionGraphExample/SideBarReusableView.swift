//
//  SideBarReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 12/8/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class SideBarReusableView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 0.9)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
