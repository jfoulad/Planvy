//
//  SpecificBusiness.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/3/23.
//

import Foundation
import UIKit

struct SpecificBusiness: Decodable, Equatable, Hashable {
    
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

    
    
    func getFormattedCategories() -> String {
        var categoriesText = ""
        for category in self.categories {
            categoriesText.append("\(category.title), ")
        }
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        
        return categoriesText
    }
    
    func getMainImage() -> UIImageView {
        let image = UIImageView()
        if let urlString = image_url {
            let url = URL(string: urlString)

            image.kf.setImage(with: url)

        }
        return image
    }
    
    
    func getPriceAndCategoryFormatted() -> String {
        if let p = price {
            return "\(p) • \(getFormattedCategories())"
        } else {
            return "• \(getFormattedCategories())"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    static func == (lhs: SpecificBusiness, rhs: SpecificBusiness) -> Bool {
        return lhs.id == rhs.id
    }
}
