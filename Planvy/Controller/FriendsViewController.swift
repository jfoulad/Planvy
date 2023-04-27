//
//  FriendsViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/4/23.
//

import UIKit
import Lottie

class FriendsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    let animationView = LottieAnimationView(name: "fourdots")
    let designManager = ColorAndFontManager.shared
    let currentUser = CurrentUser.shared
    
    @IBOutlet weak var groupsLabel: UILabel!
    
    @IBOutlet weak var addGroupButton: UIButton!
    
    @IBOutlet weak var groupCVHolder: UIView!
    
    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    @IBOutlet weak var friendListLabel: UILabel!
    
    @IBOutlet weak var searchHolderView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegates
        groupCollectionView.dataSource = self
        groupCollectionView.delegate = self
        friendCollectionView.dataSource = self
        friendCollectionView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        //Set Up UI
        setUpUI()
        
    }
    
    //add blur (thought it would be more useful than it is
    func addBlur(object: UIView) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = object.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        object.addSubview(blurEffectView)
        blurEffectView.layer.cornerRadius = object.layer.cornerRadius
        blurEffectView.clipsToBounds = true
        object.sendSubviewToBack(blurEffectView)
    }
    
    
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 4
        } else {
            return currentUser.getFriends().count
        }
    }
    
    
    //loading cell info
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCell
            
            cell.groupNameLabel.textColor = designManager.white
            cell.groupNameLabel.font = designManager.font(weight: .Bold, size: 15)
            cell.groupNameLabel.text = "Groups not yet implemented"
            
            cell.friend1Image.image = UIImage(named: "friend1")
            cell.friend2Image.image = UIImage(named: "friend2")
            cell.friend3Image.image = UIImage(named: "friend3")
            
            cell.layer.cornerRadius = 10
            cell.addButton.layer.cornerRadius = 5
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendContactCell
            
            cell.emailLabel.textColor = designManager.white
            cell.nameLabel.textColor = designManager.white
            
            cell.nameLabel.font = designManager.font(weight: .Bold, size: 17)
            cell.emailLabel.font = designManager.font(weight: .Bold, size: 14)
            
            let friend = currentUser.getSortedFriends()[indexPath.row]
            
            cell.friend = friend
            cell.nameLabel.text = friend.getFullName()
            cell.emailLabel.text = friend.getEmail()
            
            cell.layer.cornerRadius = 10
            cell.addPlanButton.layer.cornerRadius = 5
            
            return cell
        }
        
        
        
    
    }
    
    @objc func addFriendDidTapped() {
        searchBar.becomeFirstResponder()
    }
    
    
    //set up ui
    func setUpUI() {
        //--------Change font of tab bar-----------------------------------------
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: designManager.font(weight: .Regular, size: 10)], for: .normal)

        //------NAVIGATION BAR SET UP------------------------------------

        // Set navigation bar height
        let navBarHeight: CGFloat = 60
        let navBar = navigationController?.navigationBar
        navBar?.frame.size.height = navBarHeight
        
        // create right button
        let addButton = UIButton(type: .custom)

        addButton.setImage(UIImage(named: "add user"), for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        addButton.layer.backgroundColor = designManager.orange.cgColor
        addButton.layer.cornerRadius =  addButton.frame.height/2
        addButton.addTarget(self, action: #selector(addFriendDidTapped), for: .touchUpInside)

        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height))
        addButton.frame = buttonView.bounds

        buttonView.addSubview(addButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        
        // Set image as title on left side
        let title = UIImage(named: "FriendsTitleView")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: navBarHeight))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    

        
        
        //---Color/ Design UI
        groupsLabel.textColor = designManager.white
        groupsLabel.font = designManager.font(weight: .Bold, size: 12)
        
        addGroupButton.layer.cornerRadius = 10
        addBlur(object: addGroupButton)

        friendListLabel.textColor = designManager.white
        
        friendListLabel.font = designManager.font(weight: .Bold, size: 21)
        
        searchHolderView.layer.cornerRadius = 10
                
    }
    
    //when search button is clicked, try to add user
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let lowercaseEmail = searchBar.text!.lowercased()
        
        currentUser.searchForUsers(email: lowercaseEmail, onFound: { user in
            
            if self.currentUser.getFriends().contains(user) {
                //user exists, already in friendslist
                print("friend already in friendlist")
            } else {
                //user exists, add to list
                print("adding friend to list")
                self.currentUser.addFriend(friend: user)
                DispatchQueue.main.async {
                    self.friendCollectionView.reloadData()
                }
            }
            self.animationView.stop()
            self.animationView.isHidden = true
        }, onNotFound: {found in
            //user doesnt exist
            if found == false {
                print("this user doesnt exist")
            }
            
            self.animationView.stop()
            self.animationView.isHidden = true
        })
        
        startAnimation()
        
    }
    
    //loading animation
    func startAnimation() {
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        // Add constraints to center the subview horizontally and vertically
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // Add constraints to set the width and height of the subview
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        animationView.loopMode = .loop
        animationView.play()
        
    }
    
    //prepare for segue, pass relevant
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPlan" {
            if let createPlanVC = segue.destination as? CreateAPlanViewController{
                
                let button = sender as? UIButton
                let cell = button?.superview?.superview?.superview?.superview as! FriendContactCell
                
                createPlanVC.guestsArray.append(cell.friend!)
                
            }
        }
    }


}
