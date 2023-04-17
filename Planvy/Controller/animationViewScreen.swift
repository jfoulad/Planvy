//
//  animationViewScreen.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/30/23.
//

import UIKit
import Lottie

class animationViewScreen: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //lottie view from lottie api
        let animationView = LottieAnimationView(name: "logoAnimation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        // Add constraints to center the subview horizontally and vertically
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // Add constraints to set the width and height of the subview
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        animationView.loopMode = .playOnce
        animationView.play()
        
        animationView.play(completion: { finished in

            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
            logInVC.modalPresentationStyle = .fullScreen
            logInVC.modalTransitionStyle = .crossDissolve

            self.present(logInVC, animated: true)
            
        })
        
        // this one looked better, fixed the lottie and redownloadit
//        let secondsToDelay = 0.6
//        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
//           // Put any code you want to be delayed here
//            self.performSegue(withIdentifier: "fade", sender: self)
//        }
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
