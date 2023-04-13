//
//  ColorAndFontManager.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/30/23.
//

import Foundation
import UIKit


class ColorAndFontManager {
    
    let orange = UIColor(red: 249/255, green: 168/255, blue: 40/255, alpha: 1)
    let black = UIColor(red: 46/255, green: 56/255, blue: 63/255, alpha: 1)
    let blue = UIColor(red: 72/255, green: 142/255, blue: 176/255, alpha: 1)
    let red = UIColor(red: 213/255, green: 58/255, blue: 58/255, alpha: 1)
    let green = UIColor(red: 71/255, green: 148/255, blue: 47/255, alpha: 1)
    let purple = UIColor(red: 141/255, green: 32/255, blue: 181/255, alpha: 1)
    let white = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    
    let black15 = UIColor(red: 46/255, green: 56/255, blue: 63/255, alpha: 0.15)
    
    
    public static let shared = ColorAndFontManager()
    
    
    func font(weight : FontWeight, size : Int) -> UIFont {
        return UIFont(name: "Quicksand-\(weight)", size: CGFloat(size)) ?? UIFont(name: "Quicksand-Medium", size: 15)!
        
    }
    


        
    
}
