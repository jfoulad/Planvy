//
//  CreateAPlanViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/7/23.
//

import UIKit

class CreateAPlanViewController: UIViewController, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITableViewDelegate  {
    
    let currentUser = CurrentUser.shared
    let designManager = ColorAndFontManager.shared
    let yelpAPIModel = YelpApiModel.shared
    
    var guestsArray = Array<User>()
    
    var selectedGuestIndexPath: IndexPath?
    
    let tableView = UITableView()
    
    var sortedAutoCompleteArray = Array<Any>()
    
    var selectedBusiness: SpecificBusiness?
    
    
    
    
    @IBOutlet weak var createAPlanLabel: UILabel!
    
    @IBOutlet weak var eventDetailsLabel: UILabel!
    
    @IBOutlet weak var planNameTF: UITextField!
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBOutlet weak var guestsLabel: UILabel!
    
    @IBOutlet weak var addGuestTF: UITextField!
    
    @IBOutlet weak var addGuestButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var firstHolderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        planNameTF.delegate = self
        locationTF.delegate = self
        addGuestTF.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //number of itens
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guestsArray.count
    }
    //guest cells loading
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! GuestCell
        
        
        cell.nameLabel.textColor = designManager.black
        cell.nameLabel.font = designManager.font(weight: .Bold, size: 17)
        cell.holderView.layer.cornerRadius = 10
        cell.trashButton.layer.cornerRadius = 10
        cell.trashButton.layer.borderWidth = 1
        cell.trashButton.layer.borderColor = designManager.black15.cgColor
        
        let guest = guestsArray[indexPath.row]
        
        cell.guest = guest
        cell.nameLabel.text = guest.getFullName()
        
        return cell
        
    }
    
    //when trash button is clicked delete guest from plan
    @IBAction func trashGuest(_ sender: UIButton) {
        
        let cell = sender.superview?.superview as! GuestCell
        let name = cell.nameLabel.text!
        
        let index = guestsArray.firstIndex(of: cell.guest!)!
        
        guestsArray.remove(at: index)
        
        collectionView.reloadData()
        
        let model = CurrentUser.shared
        
        
    }
    
    
    
    
    
    //add guests by first name from friend list
    @IBAction func didAddGuest(_ sender: UIButton) {
        let firstName = addGuestTF.text?.lowercased()
        let friendsSet = currentUser.getFriends()
        
        var added = false
        for friend in friendsSet {
            if friend.getFirstName().lowercased() == firstName && !guestsArray.contains(friend) {
                guestsArray.append(friend)
                added = true
                addGuestTF.text = ""
            }
        }
        
        if added == false {
            print("No friend by that first name/ already added")
        }
        collectionView.reloadData()
        
    }
    
    //when location tf did change, load autocomplete and put it into array
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        if sender.text?.isEmpty == true {
            
        } else {
            yelpAPIModel.autocomplete(term: sender.text!, location: "Los Angeles", onSuccess: { [self] autocomplete in
                
                sortedAutoCompleteArray.removeAll()
                
                
                
                for index in 0..<min(2, autocomplete.terms.count) {
                    sortedAutoCompleteArray.append(autocomplete.terms[index])
                }
                
                for index in 0..<min(2, autocomplete.businesses.count) {
                    sortedAutoCompleteArray.append(autocomplete.businesses[index])
                }
                
                for index in 0..<min(2, autocomplete.categories.count) {
                    sortedAutoCompleteArray.append(autocomplete.categories[index])
                }
                
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
        }
        
    }
    
    //put table view below location tf
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            tableView.isHidden = false
            tableView.frame = CGRect(x: locationTF.frame.minX, y: locationTF.frame.maxY, width: locationTF.frame.width, height: 100)
            
            view.bringSubviewToFront(tableView)
        }
    }
    //hide text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        tableView.frame = CGRect(x: locationTF.frame.minX, y: locationTF.frame.maxY, width: locationTF.frame.width, height: 0)
        
        
    }
    
    
    //number of items in autocomplete tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedAutoCompleteArray.count
    }
    
    //load tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.font = designManager.font(weight: .Bold, size: 15)
        
        cell.textLabel?.textColor = designManager.black
        
        
        if sortedAutoCompleteArray[indexPath.row] is Business {
            let business = sortedAutoCompleteArray[indexPath.row] as! Business
            cell.textLabel?.text = business.name
            cell.detailTextLabel?.text = business.location.getFormattedAddress()
        } else if sortedAutoCompleteArray[indexPath.row] is Term {
            let term = sortedAutoCompleteArray[indexPath.row] as! Term
            cell.textLabel?.text = term.text
        } else if sortedAutoCompleteArray[indexPath.row] is Category {
            let category = sortedAutoCompleteArray[indexPath.row] as! Category
            cell.textLabel?.text = category.title
        }
        
        
        return cell
    }
    
    //when cell is selected, load business VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let term = (cell?.textLabel?.text)!
        
        if sortedAutoCompleteArray[indexPath.row] is Business {
            let business = sortedAutoCompleteArray[indexPath.row] as! Business
            let id = business.id
            
            //do segue
            
            let businessInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "businessInfo") as! BusinessInformationViewController
            
            businessInfoVC.businessID = id
            
            present(businessInfoVC, animated: true)
            
        } else {
            yelpAPIModel.getBusinessesForTerm(term: term, location: "Los Angeles", onSuccess: { businesses in
                
                self.sortedAutoCompleteArray.removeAll()
                
                for business in businesses {
                    self.sortedAutoCompleteArray.append((business))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    
    //set up UI
    func setUpUI() {
        //set up tableView
        
        tableView.frame = CGRect(x: locationTF.frame.minX, y: locationTF.frame.maxY, width: locationTF.frame.width, height: 0)
        firstHolderView.addSubview(tableView)
        firstHolderView.bringSubviewToFront(tableView)
        
        
        
        //dummy info
        
        
        //UI color and Design Set up
        createAPlanLabel.textColor = designManager.black
        createAPlanLabel.font = designManager.font(weight: .Bold, size: 25)
        
        eventDetailsLabel.textColor = designManager.black
        eventDetailsLabel.font = designManager.font(weight: .Bold, size: 13)
        
        
        planNameTF.textColor = designManager.black
        planNameTF.font = designManager.font(weight: .Bold, size: 17)
        planNameTF.borderStyle = .roundedRect
        planNameTF.layer.borderColor = UIColor.white.cgColor
        planNameTF.backgroundColor = designManager.white
        
        
        
        locationTF.textColor = designManager.black
        locationTF.font = designManager.font(weight: .Bold, size: 17)
        locationTF.borderStyle = .roundedRect
        locationTF.layer.borderColor = UIColor.white.cgColor
        locationTF.backgroundColor = designManager.white
        
        dateTimeLabel.textColor = designManager.black
        dateTimeLabel.font = designManager.font(weight: .Bold, size: 13)
        
        dateTimePicker.minimumDate = .now
        dateTimePicker.date = .now
        dateTimePicker.preferredDatePickerStyle = .compact
        //        dateTimePicker.backgroundColor = designManager.black15
        
        guestsLabel.textColor = designManager.black
        guestsLabel.font = designManager.font(weight: .Bold, size: 13)
        
        addGuestTF.textColor = designManager.black
        addGuestTF.font = designManager.font(weight: .Bold, size: 17)
        addGuestTF.borderStyle = .roundedRect
        addGuestTF.layer.borderColor = UIColor.white.cgColor
        addGuestTF.backgroundColor = designManager.white
        
        addGuestButton.layer.cornerRadius = 10
        addGuestButton.layer.borderWidth = 1
        addGuestButton.layer.borderColor = designManager.black15.cgColor
        
        
        submitButton.titleLabel?.font = designManager.font(weight: .Bold, size: 20)
        submitButton.layer.cornerRadius = 20
    }
    
    
    //    @IBAction func backgroundDidTapped(_ sender: UITapGestureRecognizer) {
    //        planNameTF.resignFirstResponder()
    //        locationTF.resignFirstResponder()
    //        addGuestTF.resignFirstResponder()
    //        print(1)
    //    }
    
    //bg tap because of bug
    @IBAction func bgTapButton(_ sender: UIButton) {
        planNameTF.resignFirstResponder()
        locationTF.resignFirstResponder()
        addGuestTF.resignFirstResponder()
        
        print(selectedBusiness)
    }
    
    //when plan is submitted, check to make sure all info is there
    @IBAction func submitButtonDidTapped(_ sender: UIButton) {
        
        if planNameTF.text?.isEmpty == true ||
            selectedBusiness == nil ||
            guestsArray.isEmpty == true {
            
            if planNameTF.text?.isEmpty == true {
                print("need plan name")
            }
            if selectedBusiness == nil {
                print("No Location selected")
            }
            if guestsArray.isEmpty == true {
                print("No Guests selected")
            }
            if dateTimePicker.date < Date() {
                print("time must be after current time")
            }
        } else {
            
            if let planName = planNameTF.text, let business = selectedBusiness {
                
                let plan = Plan(planName: planName, specificBusiness: business, dateAndTime: dateTimePicker.date, creator: currentUser.getCurrentUser(), invitees: Set(guestsArray), acceptedInvite: Set())
                
                currentUser.addPlan(plan: plan, guests: Set(guestsArray))
                
                print("Successfully added plan")
                self.dismiss(animated: true)
            }
        }
    }
    
    //reload home table view controller so plan is there
    override func viewWillDisappear(_ animated: Bool) {
        
        if let tabBar = self.presentingViewController as? UITabBarController {
            let homeNav = tabBar.viewControllers![0] as? UINavigationController
            let homeVC = homeNav?.topViewController as! HomeViewController
            
            homeVC.plansCollectionView.reloadData()
        }
        
        
    }
}
