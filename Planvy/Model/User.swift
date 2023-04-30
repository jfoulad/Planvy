//
//  User.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import Foundation
import FirebaseFirestoreSwift

//user class
class User: Hashable, Codable {
    
    @DocumentID var id: String?
    private var email: String
    private var firstName: String
    private var lastName: String
    private var password: String
    private var friendsIDSet: Set<String> = Set()
    private var friendsSet: Set<User> = Set()
    private var profilePicRef: String?
    private var plansSet: Set<Plan> = Set()
    private var groupSet: Set<Group> = Set()
    
    
    init(email: String, firstName: String, lastName: String, password: String, profilePicRef: String?) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.profilePicRef = profilePicRef
    }
    
    
    //equatable/ hashable
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.email == rhs.email)
    }
    
    //hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }
    
    
    //getters and setters
    func getFriendsID() -> Set<String> {
        return friendsIDSet
    }
    
    func setFriendsID(ids: Set<String>) {
        self.friendsIDSet = ids
    }
    
    func getFriends() -> Set<User> {
        return self.friendsSet
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getPassword() -> String {
        return password
    }
    
    func setPassword(password: String) {
        self.password = password
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
