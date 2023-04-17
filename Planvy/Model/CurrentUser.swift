//
//  CurrentUser.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class CurrentUser {
    
    private var currentUser: User?
    
    let userCollectionRef = Firestore.firestore().collection("users")
    
    let storageRef = Storage.storage().reference()
    
    
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
    
    func getCurrentUser() -> User {
        return currentUser!
    }
    
    func getFullName() -> String {
        return currentUser!.getFullName()
    }
    
    func getEmail() -> String {
        return currentUser!.getEmail()
    }
    
    func getPlans() -> Set<Plan> {
        return (currentUser?.getPlans())!
    }
    
    func getSortedPlansArray() -> Array<Plan> {
        return sortedPlansArray
    }
    
    func getID() -> String {
        return currentUser!.getID()
    }
    
    func getProfilePicRef() -> String? {
        return currentUser?.getProfilePicRef()
    }
    
    func setProfilePicRef(ref: String) {
        currentUser?.setProfilePicRef(ref: ref)
    }
    
    
    func addFriend(friend: User) {
        currentUser?.addFriend(user: friend)
        
        friend.addFriend(user: currentUser!)
        
//        print(type(of: currentUser))
//        print(type(of: friend))
//        crashing for some reason
//        updateUserToDataBase(user: friend)
//
//        updateCurrentUserToDataBase()

    }
    
    func getFriends() -> Set<User> {
        return currentUser!.getFriends()
    }
    
    func getSortedFriends() ->Array<User> {
        let friendSet = currentUser!.getFriends()
        
        let friendsArray = Array(friendSet)
        
        let sortedArray = friendsArray.sorted(by: { $0.getLastName() < $1.getLastName() })

        
        return sortedArray
    }
    
    
    func addPlan(plan: Plan, guests: Set<User>) {
        currentUser!.addPlans(plan: plan)

//        updateCurrentUserToDataBase()
        
        for guest in guests {
            guest.addPlans(plan: plan)
//            updateUserToDataBase(user: guest)
        }
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
        
//        let user1 = User(email: "mtuli@gmail.com", firstName: "Maani", lastName: "Tuli", password: "maani123")
//
//        addUserToDatabase(user: user1)
//
//        let user2 = User(email: "bnoor@gmail.com", firstName: "Brandon", lastName: "Noorvash", password: "brandon123")
//
//        addUserToDatabase(user: user2)
//
//        let user3 = User(email: "mikeshmule@gmail.com", firstName: "Mike", lastName: "Shmule", password: "mike123")
//
//        addUserToDatabase(user: user3)
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
    
    func uploadImage(image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        let imageName = currentUser!.getID()
        let imageRef = storageRef.child("profilePictures/\(imageName)")
        
        if let imageData {
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    print("Image uploaded successfully!")
                    
                }
            }
        }
        
        if currentUser?.getProfilePicRef() == nil {
            currentUser?.setProfilePicRef(ref: "profilePictures/\(imageName)")
        }
    }
    
    func getImage(onSuccess: @escaping (UIImage) -> Void) {
        
        let imageRef = storageRef.child((currentUser?.getProfilePicRef())!)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                
                if let imageData = data, let image = UIImage(data: imageData) {
                    
                    onSuccess(image)
                    
                } else {
                    print("Error creating UIImage from downloaded image data")
                }
            }
        }
    }
    
    
    
}
