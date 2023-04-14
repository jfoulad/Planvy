//
//  HoursViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/4/23.
//

import UIKit

class HoursViewController: UIViewController {
    
    let designManager = ColorAndFontManager.shared
    var formattedSchedule: Dictionary<String,String> = [:]
    
    

    @IBOutlet weak var hoursLabel: UILabel!
    
    
    @IBOutlet weak var mondayLabel: UILabel!
    
    @IBOutlet weak var tuesdayLabel: UILabel!
    
    @IBOutlet weak var wednesdayLabel: UILabel!
    
    
    @IBOutlet weak var thursdayLabel: UILabel!
    
    @IBOutlet weak var fridayLabel: UILabel!
    
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var sundayLabel: UILabel!
    
    override func viewDidLoad() {
        
//        Set up UI colors etc
        setUpUI()
    }
    
    
    
    func setUpUI() {
        hoursLabel.font = designManager.font(weight: .Bold, size: 25)
        hoursLabel.textColor = designManager.black
        
        let allDayLabels = [mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel, sundayLabel]
        
        for label in allDayLabels {
            label?.font = designManager.font(weight: .Medium, size: 17)
            label?.textColor = designManager.black
        }
    }
}
