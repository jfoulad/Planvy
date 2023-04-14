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
    
    
    @IBOutlet weak var mondayTimeLabel: UILabel!
    
    @IBOutlet weak var tuesdayTimeLabel: UILabel!
    
    @IBOutlet weak var wednesdayTimeLabel: UILabel!
    
    @IBOutlet weak var thursdayTimeLabel: UILabel!
    
    @IBOutlet weak var fridayTimeLabel: UILabel!
    
    @IBOutlet weak var saturdayTimeLabel: UILabel!
    
    @IBOutlet weak var sundayTimeLabel: UILabel!
    
    override func viewDidLoad() {
        
//        Set up UI colors etc
        setUpUI()
    }
    
    
    
    func setUpUI() {
        hoursLabel.font = designManager.font(weight: .Bold, size: 25)
        hoursLabel.textColor = designManager.black
        
        let allLabels = [mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel, sundayLabel, mondayTimeLabel, tuesdayTimeLabel, wednesdayTimeLabel, thursdayTimeLabel, fridayTimeLabel, saturdayTimeLabel, sundayTimeLabel]
        
        for label in allLabels {
            label?.font = designManager.font(weight: .Medium, size: 17)
            label?.textColor = designManager.black
            if BusinessSchedule.getTodaysDay() == label?.text {
                label?.text = "\(BusinessSchedule.getTodaysDay()) (today)"
                label?.font = designManager.font(weight: .Bold, size: 18)
            }
        }
        
        let timeLabels = [mondayTimeLabel, tuesdayTimeLabel, wednesdayTimeLabel, thursdayTimeLabel, fridayTimeLabel, saturdayTimeLabel, sundayTimeLabel]
        
        let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        
        for num in 0 ..< timeLabels.count {
            timeLabels[num]?.text = formattedSchedule[days[num]]
            if formattedSchedule[days[num]] == nil {
                timeLabels[num]?.text = "Closed"
            }
            if BusinessSchedule.getTodaysDay() == days[num] {
                timeLabels[num]?.font = designManager.font(weight: .Bold, size: 18)
            }
        }
        
    }
}
