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

        // constrain center and size
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        animationView.loopMode = .playOnce
        animationView.play()
        
        //segue to next screen when finished
        animationView.play(completion: { finished in

            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
            logInVC.modalPresentationStyle = .fullScreen
            logInVC.modalTransitionStyle = .crossDissolve

            self.present(logInVC, animated: true)
            
        })
        
        
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
