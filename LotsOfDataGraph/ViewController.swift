//
//  ViewController.swift
//  LotsOfDataGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit
import CollectionGraph

class ViewController: UIViewController {

    @IBOutlet weak var graphCollectionView: GraphCollectionView!
    
    let ppmRepo = PPMRepo()
    
}

extension ViewController: CollectionGraphDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ppmRepo.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        return ppmRepo.valueFor(indexPath: indexPath)
    }
    
}

extension ViewController: CollectionGraphDelegateLayout {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat) {
        let values = ppmRepo.getMinAndMaxCo2Values()
        
        return values
    }
    
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return 50
    }
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat) {
        let values = ppmRepo.getMinAndMaxDateFloatValues()
        
        return values
    }
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return 50
    }
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat {
        return 100
    }
    
}

