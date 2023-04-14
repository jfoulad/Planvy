//
//  LogInViewController.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/30/23.
//

import UIKit
import Lottie

class LogInViewController: UIViewController {

    
    @IBOutlet weak var continueUsingLabel: UILabel!
    
    @IBOutlet weak var orLogInLabel: UILabel!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!

    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let currentUserModel = CurrentUser.shared
    let animationView = LottieAnimationView(name: "fourdots")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        Set up UI
        setUpUI()
        
//        Added these users to firestore
//        currentUserModel.makeDummyUsers()

        
        
        //check if log in credientials match
        
        
        
    }
    
    
    @IBAction func logInDidTapped(_ sender: UIButton) {
        let email = emailTF.text
        let password = passwordTF.text
        
        
        if let email, let password {
            currentUserModel.logIn(email: email, password: password, onSuccess: {user in
                self.currentUserModel.setCurrentUser(user: user)
               
                self.animationView.stop()
                self.animationView.isHidden = true
                
                self.performSegue(withIdentifier: "logInToHome", sender: self)
            })
            
            
            startAnimation()
        }
    }
    
    
    
    func startAnimation() {
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        // Add constraints to center the subview horizontally and vertically
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // Add constraints to set the width and height of the subview
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        animationView.loopMode = .autoReverse
        animationView.play()
        
    }
    

    
    func setUpUI() {
        let designManager = ColorAndFontManager.shared
        
        let labelFont = designManager.font(weight: .Medium, size: 15)
        let textFieldFont = designManager.font(weight: .Medium, size: 18)
        
        continueUsingLabel.font = designManager.font(weight: .Medium, size: 15)
        orLogInLabel.font = labelFont
        emailTF.font = textFieldFont
        passwordTF.font = textFieldFont
        
        emailTF.borderStyle = .roundedRect
        emailTF.layer.borderColor = UIColor.white.cgColor
        emailTF.layer.borderWidth = 1.0
        emailTF.layer.cornerRadius = 5
        
        passwordTF.borderStyle = .roundedRect
        passwordTF.layer.borderColor = UIColor.white.cgColor
        passwordTF.layer.borderWidth = 1.0
        passwordTF.layer.cornerRadius = 5
        
        
        emailTF.leftViewMode = .always
        passwordTF.leftViewMode = .always
        
        let emailIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        emailIconImageView.image = UIImage(named: "password")
        
        let passwordIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        passwordIconImageView.image = UIImage(named: "email")
        
        emailTF.leftView = emailIconImageView
        passwordTF.leftView = passwordIconImageView
        
        logInButton.backgroundColor = designManager.orange
        logInButton.titleLabel?.font = designManager.font(weight: .Bold, size: 20)
        logInButton.layer.cornerRadius = 10
        
        forgotPasswordButton.titleLabel?.font = designManager.font(weight: .Bold, size: 13)
    }
}
