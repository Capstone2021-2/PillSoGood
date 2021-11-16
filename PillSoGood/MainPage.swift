//
//  MainPage.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/09/29.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        self.tabBar.tintColor = UIColor(red: 133/255, green: 177/255, blue: 248/255, alpha: 1)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

class MainPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "홈"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = nil
    }
    
    @IBAction func movesurvey(_ sender: UIButton) {
        if let surveyVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "SurveyViewController") as? SurveyViewController {
            surveyVC.title = "체질 검사"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.pushViewController(surveyVC, animated: true)
        }
        
    }

    @IBAction func moveToLifeStyle(_ sender: Any) {
        if let lifeVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "LifeStyleViewController") as? LifeStyleViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.pushViewController(lifeVC, animated: true)
        }
    }
}
