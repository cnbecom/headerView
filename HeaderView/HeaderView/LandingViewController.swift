//
//  LandingViewController.swift
//  HeaderView
//
//  Created by Becom, Chris on 6/25/18.
//

import UIKit

class LandingViewController: UIViewController {

    // MARK: Constants
    
    let homeSegue = "homeSegue"
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Action Event Handlers
    
    @IBAction func performSegueButtonActionEvent(_ sender: UIButton) {
        performSegue(withIdentifier: homeSegue, sender: self)
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
