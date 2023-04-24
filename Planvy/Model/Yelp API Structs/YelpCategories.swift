//
//  YelpCategories.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation

// Yelp categories for home page
enum YelpCategories: CaseIterable {
    case Bars
    case Arts
    case Entertainment
    case Nightlife
    case Restaurants
//    case Nature_And_Outdoors
    
    //string value of enum
    var stringValue: String {
        let string = "\(self)"
        let noSpaces = string.replacingOccurrences(of: "_", with: " ")
        let noAnd = noSpaces.replacingOccurrences(of: "And", with: "&")
        
        return noAnd
        }
    
    //randomly select a category
    public static func randomize() -> YelpCategories {
        let allCategories = YelpCategories.allCases
        let choice = allCategories.randomElement()!
        return choice
    }
}


