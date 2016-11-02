//
//  CollectionGraphDataSource.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class CollectionGraphDataSource: NSObject, UICollectionViewDataSource {

    var graphData: GraphData = GraphData(data: [])

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return graphData.sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return graphData.data[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)

        return cell
    }

}
