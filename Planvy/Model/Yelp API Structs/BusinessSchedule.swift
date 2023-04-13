//
//  BusinessSchedule.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift


struct BusinessSchedule: Codable {

//    let start: String
//    let end: String
//    //DAY  0 IS MONDAY
//    let day: Int
    
    let open: Array<Open>
    let is_open_now: Bool
    
    
//    var formattedHoursArray:  Array<String> {
//        var formatted = [String()]
//
//        for day in self.open {
//            let formattedStart = convertMilitaryToRegularTime(day.start)
//            let formattedEnd = convertMilitaryToRegularTime(day.end)
//            let formattedDash = "\(String(describing: formattedStart)) - \(String(describing: formattedEnd))"
//            formatted.append(formattedDash)
//        }
//        
//
//        return formatted
//
//    }
    
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
    
    func getTodaysDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    
    func convertMilitaryToRegularTime(_ militaryTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        if let date = dateFormatter.date(from: militaryTime) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getTodaysCloseTime() -> String {
        let todaysHours = getFormattedSchedule()[getTodaysDay()]!
        
        let array = todaysHours.split(separator: "-")
        let end = array[1].trimmingCharacters(in: .whitespaces)
        return end
    }
    
    func getTodaysOpenTime() -> String {
        let todaysHours = getFormattedSchedule()[getTodaysDay()]!
        
        let array = todaysHours.split(separator: "-")
        let open = array[0].trimmingCharacters(in: .whitespaces)
        return open
    }

    func getIsOpenToday() -> Bool {
        var isOpenToday = false
        if getFormattedSchedule().keys.contains(getTodaysDay()) {
            isOpenToday = true
        }
        return isOpenToday
    }
    
    func getTodaysHours() -> String {
        return getFormattedSchedule()[getTodaysDay()]!

    }

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
    
    func getTomorrowDay() -> String {
        let today = Date()
        let tomorrow = Date(timeIntervalSinceNow: 86400) // add 86400 seconds (1 day) to get tomorrow
        let weekday = Calendar.current.component(.weekday, from: tomorrow)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let tomorrowString = formatter.string(from: tomorrow)
        return tomorrowString
    }
    
}
