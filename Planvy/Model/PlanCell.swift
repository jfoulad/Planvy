//
//  PlanCell.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import UIKit

//cell for plan collection view on home page
class PlanCell: UICollectionViewCell {
    
    
    var plan: Plan?
    
    @IBOutlet weak var planNameLabel: UILabel!
    
    @IBOutlet weak var numberOfAttendeesLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    
    @IBOutlet weak var nameHolderView: UIView!
    
    
}
