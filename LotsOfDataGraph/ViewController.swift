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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        graphCollectionView.register(GraphLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindLine, withReuseIdentifier: .graphLayoutElementKindLine)
        graphCollectionView.register(XLabelReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindXAxisView, withReuseIdentifier: .graphLayoutElementKindXAxisView)
    }
    
}

extension ViewController: CollectionGraphDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ppmRepo.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: GraphCollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        return ppmRepo.valueFor(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case .graphLayoutElementKindLine:
            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: .graphLayoutElementKindLine,
                                                                       for: indexPath)
            return line
        default:
            let xLabel = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: .graphLayoutElementKindXAxisView,
                                                                         for: indexPath) as! XLabelReusableView
            
            let labelText = convertFloatValueToDate(xLabelValue: xLabel.value)
            xLabel.label.text = labelText

            return xLabel
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
    
    func graphCollectionView(_ graphCollectionView: GraphCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func minAndMaxYValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat) {
        let values = ppmRepo.getMinAndMaxCo2Values()
        
        return values
    }
    
    func numberOfYStepsIn(_ graphCollectionView: GraphCollectionView) -> Int {
        return 50
    }
    
    func minAndMaxXValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat) {
        let values = ppmRepo.getMinAndMaxDateFloatValues()
        
        return values
    }
    
    func numberOfXStepsIn(_ graphCollectionView: GraphCollectionView) -> Int {
        return 50
    }
    
    func distanceBetweenXStepsIn(_ graphCollectionView: GraphCollectionView) -> CGFloat {
        return 150
    }
    
}

extension ViewController: CollectionGraphXDelegate {
    
    func bottomPaddingFor(_ graphCollectionView: GraphCollectionView) -> CGFloat {
        return 36
    }
    
}

