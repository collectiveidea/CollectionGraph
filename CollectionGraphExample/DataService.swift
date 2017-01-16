//
//  SmogService.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/16/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation
import CollectionGraph

class DataService {

    let parser: Parsable

    init(parser: Parsable) {
        self.parser = parser
    }

    func fetchData(fromFile file: String, completion: @escaping ([[GraphDatum]]) -> Void) {

        let json = self.serializeJsonFile(fromFile: file)

        // Simulate server wait time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {

            if let json = json {

                let datumArray = self.parser.parse(json: json)

                completion(datumArray)
            }
        })
    }

    func serializeJsonFile(fromFile file: String) -> [[String: Any]]? {

        let path = Bundle.main.path(forResource: file, ofType: "json")

        if let path = path {

            do {
                let data = try Data(referencing: NSData(contentsOfFile: path))

                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]

                if let json = json {
                    return json
                }

            } catch {
                print("Missing the .json file")
            }
        }
        return nil
    }

}
