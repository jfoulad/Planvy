//
//  Business.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation
import UIKit
import Kingfisher


struct Business: Decodable {
    let id: String
    let name: String?
    let image_url: String?
    let rating: Double?
    let price: String?
    let location: Location
    let categories: Array<Category>

    var formattedCategories: String {
        var categoriesText = ""
        for category in self.categories {
            categoriesText.append("\(category.title), ")
        }
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        categoriesText.remove(at: categoriesText.index(before: categoriesText.endIndex))
        
        return categoriesText
        
    }
    
    var imageURLObject : UIImageView {
        let image = UIImageView()
        if let urlString = image_url {
            let url = URL(string: urlString)

            image.kf.setImage(with: url)

        }
        return image
    }
    
}
