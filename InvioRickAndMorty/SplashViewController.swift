//
//  SplashViewController.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 23.04.2023.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        let welcomeText = self.welcomeLabel

        if userDefaults.bool(forKey: "isVisited") {
            welcomeText?.text = "Hello!"
        } else {
            welcomeText?.text = "Welcome!"
            userDefaults.set(true, forKey: "isVisited")
        }

        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSplashScreen), userInfo: nil, repeats: false)
    }

    @objc func dismissSplashScreen() {
        timer.invalidate()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            navigationController?.pushViewController(mainVC, animated: true)
        }
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
