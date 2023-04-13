//
//  Plan.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import Foundation
import UIKit

class Plan: Hashable {
    

    private var planName: String
    private var specificBusiness: SpecificBusiness
    private var date: Date
    private let creator: User
    private var guests: Set<User>
    private var acceptedInvite: Set<User> = Set()
    
    
    init(planName: String, specificBusiness: SpecificBusiness, dateAndTime: Date, creator: User, invitees: Set<User>, acceptedInvite: Set<User>) {
        self.planName = planName
        self.specificBusiness = specificBusiness
        self.date = dateAndTime
        self.creator = creator
        self.guests = invitees
        self.acceptedInvite = acceptedInvite
    }

    //testtestt
    
    static func == (lhs: Plan, rhs: Plan) -> Bool {
        return lhs.specificBusiness == rhs.specificBusiness &&
                lhs.date == rhs.date &&
                lhs.guests.insert(lhs.creator) == rhs.guests.insert(rhs.creator)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(specificBusiness)
        hasher.combine(date)
        
    }
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d'\(daySuffix(for: self.date))', yyyy 'at' ha"
        return formatter.string(from: date)
    }

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
    
    func getDate() -> Date {
        return date
    }
    
    func getPlanName() -> String {
        return planName
    }
    
    func getAcceptedGuestsSet() -> Set<User> {
        return acceptedInvite
    }
    
    func getSpecificBusinessName() -> String {
        return specificBusiness.name!
    }
    
    func getSpecificBusinessLocation()-> String {
        return specificBusiness.location.getFormattedAddress()
    }
    
    
    
    
    
}
