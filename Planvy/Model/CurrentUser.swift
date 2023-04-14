//
//  CurrentUser.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation
import FirebaseFirestore


class CurrentUser {
    
    private var currentUser: User?
    
    let userCollectionRef = Firestore.firestore().collection("users")
    
    private var sortedPlansArray: Array<Plan> {
        let plansSet = currentUser!.getPlans()
        
        let planArray = Array(plansSet)
        
        let sortedArray = planArray.sorted(by: { $0.getDate() < $1.getDate() })

        
        return sortedArray
    }
    
    static let shared = CurrentUser()
    

    func isCurrentUserNil() -> Bool {
        if currentUser == nil {
            return true
        } else {
            return false
        }
    }
    
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    func getPlans() -> Set<Plan> {
        return (currentUser?.getPlans())!
    }
    
    func getSortedPlansArray() -> Array<Plan> {
        return sortedPlansArray
    }
    
    
    func addFriend(friend: User) {
        currentUser?.addFriend(user: friend)
        
        updateUserToDataBase()

    }
    
    func getFriends() -> Set<User> {
        return currentUser!.getFriends()
    }
    
    
    func addPlan(plan: Plan) {
        currentUser!.addPlans(plan: plan)

    }
    
    func addUserToDatabase(user:User) {
        do {
            let documentID = userCollectionRef.document().documentID
            try userCollectionRef.document(documentID).setData(from: user)
            try userCollectionRef.document(documentID).updateData([
                "id": "\(documentID)"
            ])
        } catch {
            print(error)
        }
    }
    
    func logIn(email: String, password: String, onSuccess: @escaping (User) -> Void) {
        userCollectionRef.getDocuments(completion: { snapshot, error in
            
            for doc in snapshot!.documents {
                let docEmail = doc.data()["email"] as? String
                let docPassword = doc.data()["password"] as? String
                
                if let docEmail, let docPassword {
                    if email == docEmail && password == docPassword {
                        
                        do {
                            let user = try doc.data(as: User.self)
                            onSuccess(user)
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        print("wrong info")
                    }
                }
            }

        })
    }
    
    func updateUserToDataBase() {
        if let id = currentUser!.id {
            let docRef = userCollectionRef.document(id)
            do {
              try docRef.setData(from: currentUser)
            }
            catch {
              print(error)
            }
          }
    }
    
    
    
    
}
