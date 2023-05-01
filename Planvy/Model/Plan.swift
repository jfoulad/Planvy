//
//  Plan.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import Foundation
import FirebaseFirestoreSwift

//plan class
class Plan: Hashable, Codable {
    
    @DocumentID var id: String?
    private var planName: String
    private var specificBusiness: SpecificBusiness
    private var date: Date
    private let creatorID: String
    private var guestsID: Set<String>

    
    
    init(planName: String, specificBusiness: SpecificBusiness, dateAndTime: Date, creatorID: String, guests: Set<String>) {
        self.planName = planName
        self.specificBusiness = specificBusiness
        self.date = dateAndTime
        self.creatorID = creatorID
        self.guestsID = guests
    }

    
    //equatable??
    static func == (lhs: Plan, rhs: Plan) -> Bool {
        return lhs.specificBusiness == rhs.specificBusiness &&
                lhs.date == rhs.date &&
                lhs.guestsID.insert(lhs.creatorID) == rhs.guestsID.insert(rhs.creatorID)
    }
    //hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(specificBusiness)
        hasher.combine(date)
        
    }
    //get formatted day string
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d'\(daySuffix(for: self.date))', yyyy 'at' ha"
        return formatter.string(from: date)
    }

    //get day suffix string
    func daySuffix(for date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
    //getters
    func getDate() -> Date {
        return date
    }
    
    func getPlanName() -> String {
        return planName
    }
    
    func getGuestsID() -> Set<String> {
        return guestsID
    }
    
    func getSpecificBusinessName() -> String {
        return specificBusiness.name!
    }
    
    func getSpecificBusinessLocation()-> String {
        return specificBusiness.location.getFormattedAddress()
    }
    
    
    
    
    
}
