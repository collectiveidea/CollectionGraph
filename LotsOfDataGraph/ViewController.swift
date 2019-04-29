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

    @IBOutlet weak var collectionGraph: CollectionGraph!
    
    let ppmRepo = PPMRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionGraph.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionGraph.collectionGraphDataSource = self
        collectionGraph.collectionGraphDelegateLayout = self
        collectionGraph.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30)
        collectionGraph.usesWholeNumbersOnYAxis = true
        collectionGraph.isLineGraph = true
        collectionGraph.hasXAxisLabels = true
        collectionGraph.hasYAxisLabels = true
        collectionGraph.hasHorizontalGraphLines = true
        collectionGraph.isBarGraph = true
        
        fetchData()
    }
    
    func fetchData() {
        ppmRepo.getPPM { (finished) in
            self.collectionGraph.reloadData()
        }
                
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.ppmRepo.insertData()
//
//            // Not supported yet
//            self.collectionGraph.collectionView.insertItems(at: [IndexPath(row: 5, section: 0)])
//        }
    }
    
}

extension ViewController: CollectionGraphDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ppmRepo.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        cell.layer.cornerRadius = cell.frame.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, valueFor indexPath: IndexPath) -> GraphValue {
        return ppmRepo.valueFor(indexPath: indexPath)
    }
    
    func textForXLabelAt(indexPath: IndexPath, fromValue value: CGFloat) -> String {
        if indexPath.item % 2 != 0 {
            return "•"
        } else {
            let labelText = self.convertFloatValueToDate(xLabelValue: value)
            return labelText
        }
    }
    
    func convertFloatValueToDate(xLabelValue value: CGFloat) -> String {
        let date = Date(timeIntervalSince1970: Double(value))
        let customFormat = DateFormatter.dateFormat(fromTemplate: "MMM d hh:mm", options: 0, locale: Locale(identifier: "us"))!
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = customFormat
        
        return formatter.string(from: date)
    }
    
}

extension ViewController: CollectionGraphDelegateLayout {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 6, height: 6)
    }
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> MinMaxValues {
        let values = ppmRepo.getMinAndMaxCo2Values()
        
        return values
    }
    
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return ppmRepo.data.isEmpty ? 0 : 6
    }
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> MinMaxValues {
        let values = ppmRepo.getMinAndMaxDateFloatValues()
        
        return values
    }
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int {
        return ppmRepo.data.isEmpty ? 0 : 50
    }
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat {
        return 150
    }
    
}
