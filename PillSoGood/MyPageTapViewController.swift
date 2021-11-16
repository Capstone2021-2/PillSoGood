//
//  MyPageTapViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/05.
//

import UIKit

class MyPageTapViewController: UIViewController {
    
    
    @IBOutlet weak var user_nickname: UILabel!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1).cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "token") == nil {
            let alertVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginAlertViewController") as! LoginAlertViewController
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: true, completion: nil)
        }

        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            user_nickname.text = nickname + " 님"
        }
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "마이페이지"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = nil
    }
    
    
    // 개인정보수정 버튼 클릭 시
    @IBAction func moveToMyInfo(_ sender: Any) {
        if let detailVC = self.storyboard!.instantiateViewController(identifier: "EditMyInformation") as? EditMyInformation {
            detailVC.title = "개인정보수정"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .lightGray
            self.navigationItem.backBarButtonItem = backBarButtonItem

            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    @IBAction func moveToReview(_ sender: Any) {
        if let detailVC = self.storyboard!.instantiateViewController(identifier: "ReviewPageViewController") as? ReviewPageViewController {
            detailVC.title = "리뷰 관리"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .lightGray
            self.navigationItem.backBarButtonItem = backBarButtonItem

            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
    
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
