//
//  CurrentUser.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

//current user singleton model
class CurrentUser {
    
    private var currentUser: User?
    
    let userCollectionRef = Firestore.firestore().collection("users")
    let planCollectionRef = Firestore.firestore().collection("plans")
    
    let storageRef = Storage.storage().reference()
    
    
    static let shared = CurrentUser()
    
    //check if current user is nil
    func isCurrentUserNil() -> Bool {
        if currentUser == nil {
            return true
        } else {
            return false
        }
    }
    
    //getters and setters
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    func getCurrentUser() -> User {
        return currentUser!
    }
    
    func getFullName() -> String {
        return currentUser!.getFullName()
    }
    
    func getFirstName() -> String {
        return currentUser!.getFirstName()
    }
    
    
    func getLastName() -> String {
        return currentUser!.getLastName()
    }
    
    func getEmail() -> String {
        return currentUser!.getEmail()
    }
    
    func getPlans() -> Set<Plan> {
        return (currentUser?.getPlans())!
    }
    
    //get plans sorted by date for user
    func getSortedPlansArray() -> Array<Plan> {
        let plansSet = currentUser!.getPlans()
        
        let planArray = Array(plansSet)
        
        let sortedArray = planArray.sorted(by: { $0.getDate() < $1.getDate() })

        
        return sortedArray
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
    
    func getFriends() -> Set<User> {
        return currentUser!.getFriends()
    }
    
    func setFriends(friends: Set<User>) {
        currentUser!.setFriends(friends: friends)
    }
    
    func setPlans(plans: Set<Plan>) {
        currentUser!.setPlans(plans: plans)
    }
    
    //change passowrd
    func changePassword(old: String, new: String) -> String {
        if old == currentUser!.getPassword() {
            currentUser?.setPassword(password: new)
//            updateCurrentUserToDataBase()
            return "Password Updated"
        } else {
            return "Old password did not match"
        }
    }
    
    //add a friend to current user and add current user as friend to friend
    func addFriend(friend: User) {
        currentUser?.addFriend(user: friend)
        
        if let currentUser {
            friend.addFriend(user: currentUser)
            addFriendsToDatabase(source: friend, target: currentUser)
            addFriendsToDatabase(source: currentUser , target: friend)
        }

    }
    
    //get friends sorted by last name
    func getSortedFriends() ->Array<User> {
        let friendSet = currentUser!.getFriends()
        
        let friendsArray = Array(friendSet)
        
        let sortedArray = friendsArray.sorted(by: { $0.getLastName() < $1.getLastName() })

        
        return sortedArray
    }
    
    //add a plan to current user and to all guests
    func addPlan(plan: Plan, guests: Set<User>) {
        currentUser!.addPlans(plan: plan)

        var everyone = Set(guests)
        everyone.insert(currentUser!)
        
        
        addPlanToDatabase(users: everyone , plan: plan)
    }
    
    //add a user to database
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
    
    //log in function
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
                        
                    }
                }
            }

        })
    }
    
    //load friend user objects to store locally
    func loadFriendUserObjects(onSuccess: @escaping (Set<User>) -> Void) {
        
        userCollectionRef.whereField(FieldPath.documentID(), in: Array(currentUser!.getFriendsID())).getDocuments(completion: {snapshot, error in
            var users = Set<User>()
            
            if let error {
                print("Errpr: \(error.localizedDescription)")
            } else {
                for doc in snapshot!.documents {
                    do {
                        let user = try doc.data(as: User.self)
                        users.insert(user)
                    } catch {
                        print(error)
                    }
                }
            }
            
            onSuccess(users)
            
        })
    }
    
    //load plan objects to store locally
    func loadPlanObjects(onSuccess: @escaping (Set<Plan>) -> Void) {
        planCollectionRef.whereField(FieldPath.documentID(), in: Array(currentUser!.getPlansID())).getDocuments(completion: {snapshot, error in
            var plans = Set<Plan>()
            
            if let error {
                print("Error: \(error.localizedDescription)")
            } else {
                for doc in snapshot!.documents {
                    do {
                        let plan = try doc.data(as: Plan.self)
                        plans.insert(plan)
                    } catch {
                        print(error)
                    }
                }
            }
            
            onSuccess(plans)
            
        })
    }
    
    //load both plan and user objects to show locally
    func loadPlanAndUserObjects(onSuccess: @escaping (Set<Plan>, Set<User>) -> Void) {
        var plans = Set<Plan>()
        var friends = Set<User>()
        
        loadPlanObjects(onSuccess: {loadedPlans in
            plans = loadedPlans
            
            self.loadFriendUserObjects(onSuccess: {loadedfriends in
                friends = loadedfriends
                onSuccess(plans, friends)
                
            })
        })
        
    }
    

    
    
    //update given user to database
    func addFriendsToDatabase(source: User, target: User) {
        if let id = source.id {
            let docRef = userCollectionRef.document(id)
                 docRef.updateData([
                    "friendsIDSet" :  FieldValue.arrayUnion([target.id!])]
                )
          }
    }
    
    //add a new plan to firestore
    func addPlanToDatabase(users: Set<User>, plan: Plan) {
        do {
            let documentID = planCollectionRef.document().documentID
            try planCollectionRef.document(documentID).setData(from: plan)
            planCollectionRef.document(documentID).updateData([
                "id": "\(documentID)"
            ])
            
            for user in users {
                userCollectionRef.document(user.id!).updateData([
                    "plansIDSet" : FieldValue.arrayUnion([documentID])
                ])
            }
        } catch {
            print(error)
        }

    }
    
    //make dummy users
    func makeDummyUsers() {
        let user1 = User(email: "jf@gmail.com", firstName: "Jeremy", lastName: "Fouladian", password: "test123", profilePicRef: "profilePictures/J8YSu87QcoeIpBmRThjK")

        addUserToDatabase(user: user1)
        
        let user4 = User(email: "mtuli@gmail.com", firstName: "Maani", lastName: "Tuli", password: "maani123", profilePicRef: nil)

        addUserToDatabase(user: user4)

        let user2 = User(email: "bnoor@gmail.com", firstName: "Brandon", lastName: "Noorvash", password: "brandon123", profilePicRef: nil)

        addUserToDatabase(user: user2)

        let user3 = User(email: "mikeshmule@gmail.com", firstName: "Mike", lastName: "Shmule", password: "mike123", profilePicRef: nil)

        addUserToDatabase(user: user3)
    }
    
    
    //search for users in database given email
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
    
    
    //upload an image to profile picture storage
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
    
    //get an image from profile picture storage
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
