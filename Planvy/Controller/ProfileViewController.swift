//
//  ProfileViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/16/23.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let designManager = ColorAndFontManager.shared
    let currentUser = CurrentUser.shared
    
    @IBOutlet weak var notifCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // Do any additional setup after loading the view.
        
        notifCollectionView.dataSource = self
        notifCollectionView.delegate = self
        
    }
    
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


        // Set image as title on left side
        let title = UIImage(named: "ProfileTitleView")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: navBarHeight))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    

        // Add button on right side
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height))
        addButton.frame = buttonView.bounds

        buttonView.addSubview(addButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        
        
        
        //---Color/ Design UI

        
                
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notifCell", for: indexPath) as! NotificationCell
        
        cell.layer.cornerRadius = 10
        
        cell.notifLabel.textColor = designManager.white
        cell.notifLabel.font = designManager.font(weight: .Medium, size: 20)
//        cell.notifLabel.verticalAlignment = .top
        
        cell.notifLabel.text = "Plan Info"
        
        return cell
    }
    


}
