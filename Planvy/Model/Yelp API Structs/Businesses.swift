//
//  Businesses.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation
import FirebaseFirestoreSwift

//Yelp API struct
struct Businesses: Codable {
    let businesses: Array<Business>
}
