//
//  YelpCategories.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation

enum YelpCategories: CaseIterable {
    case Bars
    case Arts
    case Entertainment
    case Nightlife
    case Restaurants
//    case Nature_And_Outdoors
    
    var stringValue: String {
        let string = "\(self)"
        let noSpaces = string.replacingOccurrences(of: "_", with: " ")
        let noAnd = noSpaces.replacingOccurrences(of: "And", with: "&")
        
        return noAnd
        }
    
    public static func randomize() -> YelpCategories {
        let allCategories = YelpCategories.allCases
        let choice = allCategories.randomElement()!
        return choice
    }
}


