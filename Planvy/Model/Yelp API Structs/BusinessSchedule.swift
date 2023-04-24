//
//  BusinessSchedule.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift

//Yelp API struct
struct BusinessSchedule: Codable {

    
    let open: Array<Open>
    let is_open_now: Bool
    
    
    //get formatted business schedule, key is day, value is formatted string
    func getFormattedSchedule() -> Dictionary<String, String> {
        var schedule = Dictionary<String, String>()
        
        for day in self.open {
            var today = ""
            switch day.day {
                
            case 0:
                today = "Monday"
            case 1:
                today = "Tuesday"
            case 2:
                today = "Wednesday"
            case 3:
                today = "Thursday"
            case 4:
                today = "Friday"
            case 5:
                today = "Saturday"
            default:
                today = "Sunday"
            }
            
            let formattedStart = convertMilitaryToRegularTime(day.start)!
            let formattedEnd = convertMilitaryToRegularTime(day.end)!
            let formattedDash = "\(String(describing: formattedStart)) - \(String(describing: formattedEnd))"
            
            schedule[today] = formattedDash
            
        }
        return schedule
    }
    
    //get todays day
    static func getTodaysDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    //convert military to regular time
    func convertMilitaryToRegularTime(_ militaryTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        if let date = dateFormatter.date(from: militaryTime) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    //get close time string for today
    func getTodaysCloseTime() -> String {
        let todaysHours = getFormattedSchedule()[BusinessSchedule.getTodaysDay()]!
        
        let array = todaysHours.split(separator: "-")
        let end = array[1].trimmingCharacters(in: .whitespaces)
        return end
    }
    
    //get open time string for today
    func getTodaysOpenTime() -> String {
        let todaysHours = getFormattedSchedule()[BusinessSchedule.getTodaysDay()]!
        
        let array = todaysHours.split(separator: "-")
        let open = array[0].trimmingCharacters(in: .whitespaces)
        return open
    }

    //get if the business is open today
    func getIsOpenToday() -> Bool {
        var isOpenToday = false
        if getFormattedSchedule().keys.contains(BusinessSchedule.getTodaysDay()) {
            isOpenToday = true
        }
        return isOpenToday
    }
    
    //get todays hours string
    func getTodaysHours() -> String {
        return getFormattedSchedule()[BusinessSchedule.getTodaysDay()]!

    }

    //get if business is already closed
    func getIsAlreadyClosed() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        var value = false
        let currentTimeString = formatter.string(from: Date())
        let targetTimeString = getTodaysOpenTime()

        if let currentTime = formatter.date(from: currentTimeString),
           let targetTime = formatter.date(from: targetTimeString) {
            if targetTime > currentTime {
                value = false
            } else {
                value = true
            }
        }
        return value
    }
    
    //get tomorrows days
    func getTomorrowDay() -> String {
        let tomorrow = Date(timeIntervalSinceNow: 86400)
        
//        let weekday = Calendar.current.component(.weekday, from: tomorrow)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let tomorrowString = formatter.string(from: tomorrow)
        return tomorrowString
    }
    
}
