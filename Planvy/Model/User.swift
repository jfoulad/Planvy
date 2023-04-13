//
//  User.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import Foundation
import UIKit

class User: Hashable {
    
    private var email: String
    private var firstName: String
    private var lastName: String
    private var password: String
    private var friendsSet: Set<User> = Set()
    private var profilePic: UIImage?
    private var plansSet: Set<Plan> = Set()
    private var groupSet: Set<Group> = Set()
    
    
    init(email: String, firstName: String, lastName: String, password: String, profilePic: UIImage?) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.profilePic = profilePic
    }
    
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.email == rhs.email)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }
    
    func getFriends() -> Set<User> {
        return self.friendsSet
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getPlans() -> Set<Plan> {
        return self.plansSet
    }
    
    func addPlans(plan: Plan) {
        plansSet.insert(plan)
    }
    
    func addFriend(user: User) {
        friendsSet.insert(user)
    }
    
    func addGroup(group: Group) {
        groupSet.insert(group)
    }
}
