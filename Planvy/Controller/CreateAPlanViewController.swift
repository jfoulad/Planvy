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
    
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guestsArray.count
    }
    
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
    
    
    @IBAction func trashGuest(_ sender: UIButton) {
        
        let cell = sender.superview?.superview as! GuestCell
        let name = cell.nameLabel.text!
        
        let index = guestsArray.firstIndex(of: cell.guest!)!
        
        guestsArray.remove(at: index)
        
        collectionView.reloadData()
        
        let model = CurrentUser.shared
        

    }
    
    
    

    
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            tableView.isHidden = false
            tableView.frame = CGRect(x: locationTF.frame.minX, y: locationTF.frame.maxY, width: locationTF.frame.width, height: 100)
            
            view.bringSubviewToFront(tableView)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        tableView.frame = CGRect(x: locationTF.frame.minX, y: locationTF.frame.maxY, width: locationTF.frame.width, height: 0)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedAutoCompleteArray.count
    }
    
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
    
    @IBAction func bgTapButton(_ sender: UIButton) {
                planNameTF.resignFirstResponder()
                locationTF.resignFirstResponder()
                addGuestTF.resignFirstResponder()
    }
    
}
