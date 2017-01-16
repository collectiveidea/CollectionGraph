//
//  PeopleCollectionViewCell.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/16/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell {

    private let imageView = UIImageView()

    var image = UIImage() {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true

        addSubview(imageView)

        applyConstraintsToImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyConstraintsToImage() {

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.centerXAnchor.constraint(equalTo:  centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

}
