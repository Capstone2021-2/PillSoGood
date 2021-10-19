//
//  MyPageTapViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/05.
//

import UIKit

class MyPageTapViewController: UIViewController {
    
    
    @IBOutlet weak var profileView: UIView! {
        didSet {
            profileView.layer.shadowOffset = CGSize(width: 0, height: 1)
            profileView.layer.shadowOpacity = 0.2
            profileView.layer.shadowRadius = 10
            profileView.layer.shadowColor = UIColor.lightGray.cgColor
            
            profileView.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var user_nickname: UILabel!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1).cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            user_nickname.text = nickname + " 님"
        }
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarItem.title = "마이페이지"
        self.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarItem.title = nil
    }
    
    @IBAction func moveToMyInfo(_ sender: Any) {
        
    }
    
    // 로그아웃
    @IBAction func logout(_ sender: Any) {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        let main = UIStoryboard.init(name: "Main", bundle:  nil)
        if let loginPage = main.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            loginPage.modalPresentationStyle = .fullScreen
            self.present(loginPage, animated: true, completion: nil)
        }
    }

}
