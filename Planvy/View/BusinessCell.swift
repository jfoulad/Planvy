//
//  BusinessCell.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import UIKit

//business cell for collection view for home page
class BusinessCell: UICollectionViewCell {
    
    var business: Business?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
}
