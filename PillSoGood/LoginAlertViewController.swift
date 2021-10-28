//
//  LoginAlertViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/27.
//

import UIKit

class LoginAlertViewController: UIViewController {
    
    @IBOutlet weak var viewLayout: UIView! {
        didSet {
            viewLayout.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func moveToLoginpage(_ sender: Any) {
        let main = UIStoryboard.init(name: "Main", bundle:  nil)
        if let loginPage = main.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            loginPage.modalPresentationStyle = .fullScreen
            self.present(loginPage, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeAlertView(_ sender: Any) {
        if let mainPage = self.storyboard!.instantiateViewController(withIdentifier: "TapBarController") as? UITabBarController {
            mainPage.modalPresentationStyle = .fullScreen
            self.present(mainPage, animated: false, completion: nil)
        }
    }
}
