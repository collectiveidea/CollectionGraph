//
//  ViewController.swift
//  CollectionGraphExample
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit
import CollectionGraph

class ViewController: UIViewController {
    
    @IBOutlet weak var graphCollectionView: GraphCollectionView!
    
    let milesPerDayRepo = MilesPerDayRepo()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()        
    }
    
    func registerCells() {
        let nib = UINib(nibName: "PeopleCollectionViewCell", bundle: nil)
        graphCollectionView.register(nib, forCellWithReuseIdentifier: "PeopleCell")
        
        graphCollectionView.register(GraphLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindLine, withReuseIdentifier: "GraphLine")
    }

}

extension ViewController: CollectionGraphDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let peopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath)
        return peopleCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return milesPerDayRepo.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return milesPerDayRepo.numberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: GraphCollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        return milesPerDayRepo.valueFor(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let graphLine = collectionView.dequeueReusableSupplementaryView(ofKind: .graphLayoutElementKindLine, withReuseIdentifier: "GraphLine", for: indexPath) as! GraphLineReusableView
        
        graphLine.straightLines = false
        graphLine.color = .red
        
        return graphLine
    }
    
}

extension ViewController: CollectionGraphDelegateLayout {
    
    func graphCollectionView(_ graphCollectionView: GraphCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 { return CGSize(width: 50, height: 20) }
        return CGSize(width: 30, height: 30)
    }
    
    func minAndMaxYValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat) {
        return (min: 0, max: CGFloat(milesPerDayRepo.maxMileageRan()))
    }
    
    func numberOfYStepsIn(_ graphCollectionView: GraphCollectionView) -> Int {
        return 6
    }
    
    func minAndMaxXValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat) {
        return (min: milesPerDayRepo.minDateValue(), max: milesPerDayRepo.maxDateValue())
    }

    func numberOfXStepsIn(_ graphCollectionView: GraphCollectionView) -> Int {
        return 8
    }
    
    func distanceBetweenXStepsIn(_ graphCollectionView: GraphCollectionView) -> CGFloat {
        return 100
    }

}

