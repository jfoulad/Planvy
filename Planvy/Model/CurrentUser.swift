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
        
        updateCurrentUserToDataBase()

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
                        print("wrong info per doc")
                    }
                }
            }

        })
    }
    
    func updateCurrentUserToDataBase() {
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
    
    func updateUserToDataBase(user: User) {
        if let id = user.id {
            let docRef = userCollectionRef.document(id)
            do {
              try docRef.setData(from: currentUser)
            }
            catch {
              print(error)
            }
          }
    }
    
    func makeDummyUsers() {
//        let user1 = User(email: "jf@gmail.com", firstName: "Jeremy", lastName: "Fouladian", password: "test123", profilePicURL: nil)
//
//        addUserToDatabase(user: user1)
        
        let user1 = User(email: "mtuli@gmail.com", firstName: "Maani", lastName: "Tuli", password: "maani123", profilePicURL: nil)

        addUserToDatabase(user: user1)
        
        let user2 = User(email: "bnoor@gmail.com", firstName: "Brandon", lastName: "Noorvash", password: "brandon123", profilePicURL: nil)

        addUserToDatabase(user: user2)
        
        let user3 = User(email: "mikeshmule@gmail.com", firstName: "Mike", lastName: "Shmule", password: "mike123", profilePicURL: nil)

        addUserToDatabase(user: user3)
    }
    
    
    func searchForUsers(email: String, onFound: @escaping (User) -> Void, onNotFound: @escaping (Bool) -> Void) {
        userCollectionRef.getDocuments(completion: { snapshot, error in
            
            var found = false
            
            for doc in snapshot!.documents {
                let docEmail = doc.data()["email"] as? String
                
                if let docEmail {
                    if email == docEmail {
                        
                        do {
                            let user = try doc.data(as: User.self)
                            onFound(user)
                            found = true
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        
                    }
                }
            }
            onNotFound(found)
        })
    }
    
    
    
}
