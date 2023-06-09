//
//  BusinessInformationViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/3/23.
//

import UIKit
import Kingfisher
import SkeletonView

class BusinessInformationViewController: UIViewController {

    var businessID: String!
    var business: SpecificBusiness!
    
    let yelpManager = YelpApiModel.shared
    let designManager = ColorAndFontManager.shared
    
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingStar: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceAndCategoriesLabel: UILabel!
    
    @IBOutlet weak var closedOpenLabel: UILabel!
    
    @IBOutlet weak var todayClosingTimeLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    
    @IBOutlet weak var seeHoursButton: UIButton!
    
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deilveryCheck: UIImageView!
    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var pickupCheck: UIImageView!
    
    @IBOutlet weak var reservationsLabel: UILabel!
    
    @IBOutlet weak var reservationsCheck: UIImageView!
    
    @IBOutlet weak var businessInfoHolderView: UIView!
    
    @IBOutlet weak var transactionsHolderView: UIView!
    
    @IBOutlet weak var imageAndTitleHolderView: UIView!
    
    @IBOutlet weak var inviteFriendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Set up UI
        setUpUI()


    }
    
    //toggle skeleton when view will apear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleSkeloton(onOrOff: true)
        
        
    }
    
    //after view appears load business- when i loaded early the skeleton appeared for too short of a time looked weird
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBusiness(businessID: businessID)
    }
    
    //when hours did tapped, pass info to next VC and trigger segue
    @IBAction func seeAllHoursDidTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hoursVC = storyboard.instantiateViewController(withIdentifier: "hoursVC") as! HoursViewController
        
        hoursVC.formattedSchedule = (business.hours.first?.getFormattedSchedule())!
                
                if let presentationController = hoursVC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()] 
                }
                
                self.present(hoursVC, animated: true)
        
        
    }
    
    
    //    load specific business
        func loadBusiness(businessID: String) -> Void {
            yelpManager.getBusiness(businessID: businessID, onSuccess: {selectedBusiness in
                self.business = selectedBusiness
                if self.business != nil {
                    DispatchQueue.main.async {
                        self.toggleSkeloton(onOrOff: false)
                        self.setUIText()
                    }
                }
            }, onFail: { error in
                if error != nil {
                    print(error)
                }
                
            })
        }
    
    
    //set text for after the business is loaded
    func setUIText() {
        
        //---title image
        if let urlString = business.image_url {
            let url = URL(string: urlString)

            let frame = titleImage.frame
            let backgroundImage = UIImageView(frame: frame)
            backgroundImage.kf.setImage(with: url)

            titleImage.image = backgroundImage.image
        }
        //--Business Name, Pricing, and Categories
        businessNameLabel.text = business.name
        priceAndCategoriesLabel.text = business.getPriceAndCategoryFormatted()
        
        
        //button
        inviteFriendButton.setTitle("Invite a friend to \(business.name!)", for: .normal)
        
        
        //-- Todays hours
        if let businessSchedule = business.hours.first {
            if !businessSchedule.getIsOpenToday() {
                closedOpenLabel.text = "Closed Today"
                closedOpenLabel.textColor = designManager.red
                todayClosingTimeLabel.text = ""
            } else {
                if businessSchedule.is_open_now {
                    closedOpenLabel.text = "Open"
                    closedOpenLabel.textColor = designManager.green
                    todayClosingTimeLabel.text = "until \(businessSchedule.getTodaysCloseTime())"

                } else if !businessSchedule.is_open_now && businessSchedule.getIsAlreadyClosed() {
                    closedOpenLabel.text = "Closed now"
                    closedOpenLabel.textColor = designManager.red
                    todayClosingTimeLabel.text = "\(businessSchedule.getFormattedSchedule()[businessSchedule.getTomorrowDay()])"
                } else {
                    closedOpenLabel.text = "Closed"
                    closedOpenLabel.textColor = designManager.red
                    todayClosingTimeLabel.text = "• \(businessSchedule.getTodaysHours())"
                    
                }
            }
        }
        
        if business.transactions.isEmpty == true {
            transactionsHolderView.isHidden = true
        } else {
            for transaction in business.transactions {
                switch transaction {
                case "delivery":
                    deilveryCheck.image = UIImage(named: "check selected")
                case "pickup":
                    pickupCheck.image = UIImage(named: "check selected")
                case "restaurant_reservation":
                    reservationsCheck.image = UIImage(named: "check selected")
                default: break
                    
                }
            }
        }
        
        
                
    }
    
    //turn skeleton off/on
    func toggleSkeloton (onOrOff : Bool) {
        
        
        if onOrOff == true {
            imageAndTitleHolderView.showAnimatedGradientSkeleton()
            businessInfoHolderView.showAnimatedGradientSkeleton()
            transactionsHolderView.showAnimatedGradientSkeleton()
            inviteFriendButton.showAnimatedSkeleton()
            
        } else {
            imageAndTitleHolderView.hideSkeleton()
            businessInfoHolderView.hideSkeleton()
            transactionsHolderView.hideSkeleton()
            inviteFriendButton.hideSkeleton()
        }
        
        
    }
    
    //set up ui
    func setUpUI() {
        //----set skeltonable equal to font
        businessNameLabel.skeletonTextLineHeight = .relativeToFont
        ratingLabel.skeletonTextLineHeight = .relativeToFont
        priceAndCategoriesLabel.skeletonTextLineHeight = .relativeToFont
        closedOpenLabel.skeletonTextLineHeight = .relativeToFont
        deliveryLabel.skeletonTextLineHeight = .relativeToFont
        pickupLabel.skeletonTextLineHeight = .relativeToFont
        reservationsLabel.skeletonTextLineHeight = .relativeToFont
        inviteFriendButton.titleLabel?.skeletonTextLineHeight = .relativeToFont
        
        //----Font Coloring/ UI Positioning set up
        let firstViewFont = designManager.font(weight: .Bold, size: 23)
        
        seeHoursButton.contentVerticalAlignment = .bottom
        seeHoursButton.contentHorizontalAlignment = .left
        businessNameLabel.font = designManager.font(weight: .Bold, size: 25)
        businessNameLabel.textColor = designManager.white
        closedOpenLabel.font = firstViewFont
        closedOpenLabel.textColor = designManager.black
        priceAndCategoriesLabel.font = firstViewFont
        priceAndCategoriesLabel.textColor = designManager.black
        todayClosingTimeLabel.font = firstViewFont
        todayClosingTimeLabel.textColor = designManager.black
        deliveryLabel.textColor = designManager.black
        deliveryLabel.font = firstViewFont
        deliveryLabel.textColor = designManager.black
        pickupLabel.font = firstViewFont
        pickupLabel.textColor = designManager.black
        reservationsLabel.font = firstViewFont
        reservationsLabel.textColor = designManager.black
        ratingLabel.font = designManager.font(weight: .Bold, size: 19)
        ratingLabel.textColor = designManager.white
        
        
        seeHoursButton.titleLabel?.font = firstViewFont
        seeHoursButton.titleLabel?.textColor = designManager.blue
        
        
        inviteFriendButton.titleLabel?.font = designManager.font(weight: .Bold, size: 20)
        inviteFriendButton.layer.cornerRadius = 20
    }
    
    
    //when invite button tapped either go back to create a plan or create a new one while passinging in the current business
    @IBAction func businessSelectedDidtapped(_ sender: UIButton) {
        
        if let tabBar = self.presentingViewController as? UITabBarController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var vc = storyboard.instantiateViewController(withIdentifier: "createPlanVC")
            
            //cant pass, also doesnt work
            
            if let createVC = vc as? CreateAPlanViewController {
                createVC.selectedBusiness = self.business
                self.present(createVC, animated: true)
            }
            
            
            
        }
        
        if let createVC = self.presentingViewController as? CreateAPlanViewController {
            createVC.selectedBusiness = self.business
            createVC.locationTF.text = business.name
            createVC.locationTF.resignFirstResponder()
            self.dismiss(animated: true)
        }
        
    }
    
    //when view disappears also might need to pass in business/ reload home collection view depending when it originated
    override func viewWillDisappear(_ animated: Bool) {
        
        if let createVC = self.presentingViewController as? CreateAPlanViewController {
            if createVC.selectedBusiness == self.business {
                createVC.locationTF.resignFirstResponder()
            }
        }
        
        if let tabBar = self.presentingViewController as? UITabBarController {
            let homeNav = tabBar.viewControllers![0] as? UINavigationController
            let homeVC = homeNav?.topViewController as! HomeViewController
            
            homeVC.plansCollectionView.reloadData()
        }
        
        

    }

    
    
}
