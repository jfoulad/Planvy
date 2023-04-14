//
//  HomeViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/30/23.
//

import UIKit
import Kingfisher
import CoreLocation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let currentUserModel = CurrentUser.shared
    let locationManager = CLLocationManager()
    let designManager = ColorAndFontManager.shared
    let yelpManager = YelpApiModel.shared
    var currentHotspotCategory: YelpCategories?
    
    var currentHotspotBusinesses: Array<Business> = Array()
    
    @IBOutlet weak var plansCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHolderView1: UIView!
    
    @IBOutlet weak var collectionViewHolderView2: UIView!
    
    @IBOutlet weak var upcomingEventsLabel: UILabel!
    @IBOutlet weak var localHotspotsLabel: UILabel!
    
    @IBOutlet weak var hotspotsCollectionView: UICollectionView!
    
    @IBOutlet weak var hotspotsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //----- Set Up UI
        setUpUI()
        
        
        
                
        // Do any additional setup after loading the view.
        // setting up nav bar took me 2 hours and didnt even center align button or connect addbutton function correctly
        
        //------CLlocation------------
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        
        
        //-----------Start Hotspot Loading--------------------------------------
        currentHotspotCategory = YelpCategories.randomize()
//        currentHotspotCategory = YelpCategories.Arts
        loadHotspots()
        hotspotsButton.setTitle(currentHotspotCategory?.stringValue, for: .normal)
        
        
        
    
    }
    
    //supposed to trigger on addbutton
    @objc func addButtonDidTapped(_ sender: UITapGestureRecognizer? = nil) {
        print("test")
    }
    
    
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            let currentPlanCount = currentUserModel.getPlans().count
            
            if currentPlanCount == 0 {
                return 1
            } else {
                return currentPlanCount
            }
            
        } else {
            return currentHotspotBusinesses.count
        }
    }
    
    
    //loading cell info
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.tag == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planCell", for: indexPath) as! PlanCell

                    cell.planNameLabel.font = designManager.font(weight: .Bold, size: 16)
                    cell.numberOfAttendeesLabel.font = designManager.font(weight: .Bold, size: 16)
                    cell.locationLabel.font = designManager.font(weight: .Bold, size: 13)
                    cell.dateTimeLabel.font = designManager.font(weight: .Bold, size: 13)
                    cell.backgroundColor = designManager.black
                    cell.layer.cornerRadius = 10
            
            if currentUserModel.getPlans().count == 0 {
                cell.nameHolderView.isHidden = true
            } else {
                let plan = currentUserModel.getSortedPlansArray()[indexPath.row]
                
                cell.planNameLabel.text = plan.getPlanName()
                cell.numberOfAttendeesLabel.text = "\(plan.getAcceptedGuestsSet().count + 1)"
                cell.locationLabel.text = plan.getSpecificBusinessLocation()
                cell.dateTimeLabel.text = plan.getFormattedDate()
            }
            

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businessCell", for: indexPath) as! BusinessCell

            let business = currentHotspotBusinesses[indexPath.row]
//            let business = yelpManager.businessesArray[indexPath.row]
            cell.nameLabel.text = business.name
            cell.locationLabel.text = business.location.getFormattedAddress()
            cell.ratingLabel.text = "\(String(describing: business.rating!))"
            cell.categoryLabel.text = business.getFormattedCategories()

            if let urlString = business.image_url {
                let url = URL(string: urlString)

                var backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 160))
                backgroundImage.kf.setImage(with: url)

                cell.backgroundView = backgroundImage
            }
            
            
            cell.nameLabel.font = designManager.font(weight: .Bold, size: 16)
            cell.ratingLabel.font = designManager.font(weight: .Bold, size: 16)
            cell.locationLabel.font = designManager.font(weight: .Bold, size: 13)
            cell.categoryLabel.font = designManager.font(weight: .Bold, size: 13)
            cell.backgroundColor = designManager.black
            cell.layer.cornerRadius = 10
            
            return cell
        }
    }
    
    
    //random select from enum and reload hotspots
    @IBAction func hotspotsDidTapped(_ sender: UIButton) {
        
        currentHotspotCategory = YelpCategories.randomize()
        loadHotspots()
        
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            sender.transform = CGAffineTransform(translationX: 0, y: -10)
        })
        
        animator.addCompletion {_ in
            sender.transform = CGAffineTransform(translationX: 0, y: 10)
            
            let animateBackToCenter = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
                sender.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
            animateBackToCenter.startAnimation()
            
        }
        
        animator.startAnimation()

        sender.setTitle(currentHotspotCategory?.stringValue, for: .normal)
    }
    
    
    //calls singleton to load businesses for collection view
    func loadHotspots () {
        yelpManager.getBusinessesForTerm(term: currentHotspotCategory!.stringValue, location: "Los Angeles", onSuccess: {businesses in
            
            self.currentHotspotBusinesses = businesses
            
            DispatchQueue.main.async {
//            self.currentHotspotBusinesses = businesses
            
            self.hotspotsCollectionView.reloadData()
        }})
    }
    
    
    
    
    // prepare for segue
    // either call load business to pass into next VC
    //or other

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getBusiness" {
            if let businessInfoVC = segue.destination as? BusinessInformationViewController {

                
                let indexpath = hotspotsCollectionView.indexPathsForSelectedItems!.first!.row

                businessInfoVC.businessID = currentHotspotBusinesses[indexpath].id
                
    
            
    
            }
        }
    }
    
    func setUpUI() {
        //--------Change font of tab bar-----------------------------------------
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: designManager.font(weight: .Regular, size: 10)], for: .normal)
        
        
        //------NAVIGATION BAR SET UP------------------------------------
        
        // create right button
        let addButton = UIButton(type: .custom)

        addButton.setImage(UIImage(named: "add white"), for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        addButton.layer.backgroundColor = designManager.orange.cgColor
        addButton.layer.cornerRadius =  addButton.frame.height/2
        
        
        
        // Set navigation bar height
        let navBarHeight: CGFloat = 60
        let navBar = navigationController?.navigationBar
        navBar?.frame.size.height = navBarHeight

        // Set image as title on left side
        let logo = UIImage(named: "logo small")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: navBarHeight))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        

        // Add button on right side
        
//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "add white"), style: .plain, target: self, action: #selector(addButtonDidTapped))
//        rightBarButtonItem.customView?.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
//        rightBarButtonItem.customView?.layer.cornerRadius = (rightBarButtonItem.customView?.frame.height)!/2
//        rightBarButtonItem.customView?.backgroundColor = designManager.orange
//
//
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height))
        addButton.frame = buttonView.bounds

        buttonView.addSubview(addButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        
        
        //----------FUNCTION NOT LINKING
//        navigationItem.rightBarButtonItem?.target = self
//        navigationItem.rightBarButtonItem?.action = #selector(addButtonDidTapped)
//        print(navigationItem.rightBarButtonItem?.action)
//        print(navigationItem.rightBarButtonItem?.target)
        
        
//        let gestureTap = UIGestureRecognizer(target: self, action: #selector(self.addButtonDidTapped(_:)))
//
//
//        navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(gestureTap)

        

        // CENTER ALIGN
        
        //--------Collection View Holder UI------------------------------
        
        // add blurring
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = collectionViewHolderView1.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionViewHolderView1.addSubview(blurEffectView)
        collectionViewHolderView1.layer.cornerRadius = 20
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true

        let blurEffect2 = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect2)
        blurEffectView2.frame = collectionViewHolderView2.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionViewHolderView2.addSubview(blurEffectView2)
        collectionViewHolderView2.layer.cornerRadius = 20
        blurEffectView2.layer.cornerRadius = 20
        blurEffectView2.clipsToBounds = true
        
        //bring labels to front
        collectionViewHolderView1.bringSubviewToFront(upcomingEventsLabel)
        upcomingEventsLabel.font = designManager.font(weight: .Bold, size: 15)
        upcomingEventsLabel.textColor = designManager.white
        
        collectionViewHolderView2.bringSubviewToFront(localHotspotsLabel)
        localHotspotsLabel.font = designManager.font(weight: .Bold, size: 15)
        localHotspotsLabel.textColor = designManager.white
        
        
        //bring actual collection views to front
        collectionViewHolderView1.bringSubviewToFront(plansCollectionView)
        
        collectionViewHolderView2.bringSubviewToFront(hotspotsCollectionView)
        
        //bring hotspot button to front
        collectionViewHolderView2.bringSubviewToFront(hotspotsButton)
        
        hotspotsButton.contentHorizontalAlignment = .left
        hotspotsButton.titleLabel?.font = designManager.font(weight: .Bold, size: 15)
        hotspotsButton.tintColor = designManager.orange
    }
    
    
    
}
