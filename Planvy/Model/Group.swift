//
//  Group.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation


class Group: Hashable {

    
    private var members: Set<User>
    
    init(members: Set<User>) {
        self.members = members
    }
    
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.members == rhs.members
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(members)
    }
    
}
