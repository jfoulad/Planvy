//
//  Business.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation
import Kingfisher
import FirebaseFirestoreSwift


struct Business: Codable {
    let id: String
    let name: String?
    let image_url: String?
    let rating: Double?
    let price: String?
    let location: Location
    let categories: Array<Category>

    
    func getFormattedCategories() -> String {
        var categoriesText = ""
        for category in self.categories {
            categoriesText.append("\(category.title), ")
        }
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        
        return categoriesText
    }
    
    
}
