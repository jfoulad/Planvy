//
//  User.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import Foundation
import FirebaseFirestoreSwift


class User: Hashable, Codable {
    
    @DocumentID var id: String?
    private var email: String
    private var firstName: String
    private var lastName: String
    private var password: String
    private var friendsSet: Set<User> = Set()
    private var profilePicRef: String?
    private var plansSet: Set<Plan> = Set()
    private var groupSet: Set<Group> = Set()
    
    
    init(email: String, firstName: String, lastName: String, password: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.profilePicRef = nil
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
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getFullName() -> String {
        let fullName = "\(self.firstName) \(self.lastName)"
        return fullName
    }
    
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getID() -> String {
        return id!
    }
    
    func getProfilePicRef() -> String? {
        return profilePicRef
    }
    
    func setProfilePicRef(ref: String) {
       profilePicRef = ref
    }
    
}
