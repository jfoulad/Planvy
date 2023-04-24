//
//  SpecificBusiness.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift

//Yelp API struct
struct SpecificBusiness: Codable, Equatable, Hashable {
    
    let id: String
    let name: String?
    let image_url: String?
    let rating: Double?
    let price: String?
    let location: Location
    let categories: Array<Category>
    let display_phone: String?
    let photos: Array<String>?
    var hours: Array<BusinessSchedule> = Array()
    let transactions: Array<String?>

    
    // get formatted categories string
    func getFormattedCategories() -> String {
        var categoriesText = ""
        for category in self.categories {
            categoriesText.append("\(category.title), ")
        }
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        
        return categoriesText
    }
    
    
    //get formatted price and categories string
    func getPriceAndCategoryFormatted() -> String {
        if let p = price {
            return "\(p) • \(getFormattedCategories())"
        } else {
            return "• \(getFormattedCategories())"
        }
    }
    
    //code for hasher
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    //code for equatable
    static func == (lhs: SpecificBusiness, rhs: SpecificBusiness) -> Bool {
        return lhs.id == rhs.id
    }
}
