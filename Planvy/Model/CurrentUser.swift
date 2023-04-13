//
//  CurrentUser.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation


class CurrentUser {
    
    private var currentUser: User?
    
    
    private var sortedPlansArray: Array<Plan> {
        let plansSet = currentUser!.getPlans()
        
        let planArray = Array(plansSet)
        
        let sortedArray = planArray.sorted(by: { $0.getDate() < $1.getDate() })

        
        return sortedArray
    }
    
    static let shared = CurrentUser()
    

    
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    func getPlans() -> Set<Plan> {
        return (currentUser!.getPlans())
    }
    
    func getSortedPlansArray() -> Array<Plan> {
        return sortedPlansArray
    }
    
    
    func addPlan(plan: Plan) {
        currentUser!.addPlans(plan: plan)
    }
    
    
    
    
    
    
}
