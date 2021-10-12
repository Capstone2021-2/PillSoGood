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
        
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//
//    }
    
}

class MainPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarItem.title = "홈"
        self.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarItem.title = nil
    }

}
