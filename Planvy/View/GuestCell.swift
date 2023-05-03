//
//  GuestCell.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/7/23.
//

import UIKit

//guest cell for create a plan screen collection view
class GuestCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var trashButton: UIButton!
    
    var guest: User? = nil
    
    
}
