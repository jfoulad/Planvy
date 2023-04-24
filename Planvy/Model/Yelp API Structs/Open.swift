//
//  Open.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/4/23.
//

import Foundation
import FirebaseFirestoreSwift

//Yelp API struct
struct Open: Codable {
    
    
    let start: String
    let end: String
    //DAY  0 IS MONDAY
    let day: Int
}
