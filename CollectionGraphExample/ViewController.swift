//
//  ViewController.swift
//  CollectionGraphExample
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit
import CollectionGraph

protocol GraphCellRepresentable {
    func cellInstance(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}


class PeopleCellViewModel: GraphCellRepresentable {
    
    var data: String!
    
    init(data: String) {
        self.data = data
    }
    
    func cellInstance(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let peopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath)
        
        return peopleCell
    }
    
}


class ViewController: UIViewController {
    
    
    @IBOutlet weak var graphCollectionView: GraphCollectionView!
    
    let data: [GraphCellRepresentable] = [
        PeopleCellViewModel(data: "Ben Lambert"),
        PeopleCellViewModel(data: "Chris Rittersdorf"),
        PeopleCellViewModel(data: "Josh Kovach"),
        PeopleCellViewModel(data: "Tim Buguai"),
        PeopleCellViewModel(data: "Victoria Gonda")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        registerCells()
        
        graphCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func registerCells() {
        let nib = UINib(nibName: "PeopleCollectionViewCell", bundle: nil)
        graphCollectionView.register(nib, forCellWithReuseIdentifier: "PeopleCell")
    }

}

extension ViewController: CollectionGraphDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.row].cellInstance(for: collectionView, at: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, pointFor indexPath: IndexPath) -> CGPoint {
        return CGPoint(x: indexPath.item, y: indexPath.item)
    }
    
}

extension ViewController: CollectionGraphDelegateLayout {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 { return CGSize(width: 50, height: 20) }
        return CGSize(width: 30, height: 30)
    }
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat) {
        return (min: 0, max: CGFloat(data.count))
    }
    
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return 6
    }
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat) {
        return (min: 0, max: CGFloat(data.count))
    }

    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return 3
    }
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat {
        return 50
    }
}

