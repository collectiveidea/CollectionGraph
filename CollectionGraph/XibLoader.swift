//
//  XibLoader.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class XibLoader: NSObject {

    class func viewFromXib(name: String, owner: NSObject) -> UIView? {

        let bundle = Bundle(for: self.classForCoder())

        let nib = UINib(nibName: name, bundle: bundle)

        let nibView = nib.instantiate(withOwner: owner, options: nil)[0] as? UIView

        return nibView
    }

}
