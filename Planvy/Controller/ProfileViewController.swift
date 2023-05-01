//
//  ProfileViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/16/23.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    let designManager = ColorAndFontManager.shared
    let currentUser = CurrentUser.shared
    let animationView = LottieAnimationView(name: "fourdots")

    
    @IBOutlet weak var notifCollectionView: UICollectionView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var firstHolderView: UIView!
    
    @IBOutlet weak var changePhotoButton: UIButton!
    
    @IBOutlet weak var notificationsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // Do any additional setup after loading the view.
        
        notifCollectionView.dataSource = self
        notifCollectionView.delegate = self
        
    }
    
    
    @IBAction func changePhotoDidTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        let image = info[.originalImage] as! UIImage
        
        currentUser.uploadImage(image: image, onSuccess: {_ in
            
            self.animationView.stop()
            self.animationView.isHidden = true
            
            picker.dismiss(animated: true, completion: {
                self.profilePicture.showAnimatedGradientSkeleton()
                
                //Load Image
                self.currentUser.getImage(onSuccess: {image in
                    self.profilePicture.hideSkeleton()
                    self.profilePicture.image = image
                    self.profilePicture.contentMode = .scaleAspectFill
                    self.profilePicture.layer.cornerRadius = self.profilePicture.bounds.height/2
                    
                })
            })
            
        })
        startAnimation()
        
    }
    
    //loading animation start
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
    
    //set up UI
    func setUpUI() {
        
        profilePicture.showAnimatedGradientSkeleton()
        
        //Load Image
        currentUser.getImage(onSuccess: {image in
            self.profilePicture.hideSkeleton()
            self.profilePicture.image = image
            self.profilePicture.contentMode = .scaleAspectFill
            self.profilePicture.layer.cornerRadius = self.profilePicture.bounds.height/2
            
        })
        
        //--------Change font of tab bar-----------------------------------------
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: designManager.font(weight: .Regular, size: 10)], for: .normal)

        //------NAVIGATION BAR SET UP------------------------------------

        // Set navigation bar height
        let navBarHeight: CGFloat = 60
        let navBar = navigationController?.navigationBar
        navBar?.frame.size.height = navBarHeight
        
        // create right button
        let addButton = UIButton(type: .custom)

        addButton.setImage(UIImage(named: "settings"), for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        addButton.layer.backgroundColor = designManager.orange.cgColor
        addButton.layer.cornerRadius =  addButton.frame.height/2
        addButton.addTarget(self, action: #selector(settingsButtonDidTapped), for: .touchUpInside)

        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height))
        addButton.frame = buttonView.bounds

        buttonView.addSubview(addButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
        
        
        // Set image as title on left side
        let title = UIImage(named: "ProfileTitleView")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: navBarHeight))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    


        
        
        //---Color/ Design UI/Skeleton
        
        changePhotoButton.contentHorizontalAlignment = .left
        changePhotoButton.titleLabel?.font = designManager.font(weight: .Bold, size: 18)
        changePhotoButton.titleLabel?.textColor = designManager.black
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.height/2
        
        
        
        let labels = [nameLabel, emailLabel, notificationsLabel]
        
        for label in labels {
            label?.textColor = designManager.white
        }
        
        nameLabel.font = designManager.font(weight: .Bold, size: 22)
        emailLabel.font = designManager.font(weight: .Medium, size: 17)
        
        notificationsLabel.font = designManager.font(weight: .Bold, size: 24)
        
        firstHolderView.layer.cornerRadius = 10
        
        //---Setting Labels
        nameLabel.text = currentUser.getFullName()
        emailLabel.text = currentUser.getEmail()
    }
    
    //number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //load notification cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notifCell", for: indexPath) as! NotificationCell
        
        cell.layer.cornerRadius = 10
        
        cell.notifLabel.textColor = designManager.white
        cell.notifLabel.font = designManager.font(weight: .Medium, size: 20)
//        cell.notifLabel.verticalAlignment = .top
        
        cell.notifLabel.text = "Not Yet Implemented"
        
        return cell
    }
    
    //trigger profile settings alerts
    @objc func settingsButtonDidTapped() {
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)

        let changePassword = UIAlertAction(title: "Change Password", style: .default) { (_) in
            
            let alert = UIAlertController(title: "Change your password", message: nil, preferredStyle: .alert)
            
            var textFields = Array<UITextField>()
            
            alert.addTextField( configurationHandler: { tf in
                tf.placeholder = "Old Password"
                textFields.append(tf)
                
            })
            
            alert.addTextField( configurationHandler: { tf in
                tf.placeholder = "New Password"
                textFields.append(tf)
            })
            
            
            let updateAction = UIAlertAction(title: "Update", style: .default, handler: { alert in
                if let old = textFields.first?.text, let new = textFields.last?.text {
                    
                    let resultString = self.currentUser.changePassword(old: old, new: new)
                    
                    let result = UIAlertController(title: resultString, message: nil, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    result.addAction(okAction)
                    self.present(result, animated: true)
                }

                
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            
            alert.addAction(updateAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        actionSheet.addAction(changePassword)
        actionSheet.addAction(cancelButton)

        present(actionSheet, animated: true, completion: nil)
    }
    
        
}
