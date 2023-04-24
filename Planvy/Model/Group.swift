//
//  Group.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation
import FirebaseFirestoreSwift

//group class
class Group: Hashable, Codable {

    
    private var members: Set<User>
    
    init(members: Set<User>) {
        self.members = members
    }
    
    //hashable/equatable code
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.members == rhs.members
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(members)
    }
    
}
