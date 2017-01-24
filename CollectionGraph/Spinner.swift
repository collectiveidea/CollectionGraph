//
//  Spinner.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/24/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit

class Spinner: UIView {

    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)

        stylize()

        addSpinner()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stylize() {

        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 3

        alpha = 0
    }

    func addConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        if let superview = superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
            widthAnchor.constraint(equalToConstant: 35).isActive = true
            heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
    }

    func addSpinner() {
        addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        spinner.startAnimating()
    }

    func fadeOut() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.spinner.stopAnimating()
        })
    }

    func fadeIn() {
        spinner.startAnimating()

        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 1
        }, completion: nil)
    }

    override func didMoveToSuperview() {
        addConstraints()
    }
}
