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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Action Event Handlers
    
    @IBAction func performSegueButtonActionEvent(_ sender: UIButton) {
        performSegue(withIdentifier: homeSegue, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == homeSegue, let _ = segue.destination as? HomeViewController {
            title = ""
        }
    }

}
