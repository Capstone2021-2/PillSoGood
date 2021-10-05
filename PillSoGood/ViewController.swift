//
//  ViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/09/28.
//

import UIKit

enum PasswordType {
    case show
    case hide
}

class ViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!   // 비밀번호
    @IBOutlet weak var hideAndShowButton: UIImageView! {
        didSet {
            hideAndShowButton.isUserInteractionEnabled = true
            hideAndShowButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType)))
        }
    }
    var Ptype = PasswordType.hide
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // 회원가입 버튼
    @IBAction func moveToJoin(_ sender: Any) {
        let detailVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    // 아이디 비밀번호 찾기 버튼
    @IBAction func findInfo(_ sender: Any) {
        let detailVC = FindInfoViewController(nibName: "FindInfoViewController", bundle: nil)
        self.present(detailVC, animated: true, completion: nil)
    }
    
    
    // 비밀번호 옆에 눈 모양 클릭 시
    @objc func selectPasswordType() {
        if Ptype == .hide { // 비밀번호 숨김 상태에서 버튼누를 때
            password.isSecureTextEntry = false
            hideAndShowButton.image = UIImage(systemName: "eye")
            Ptype = .show
        } else {    // 비밀번호 보임 상태에서 버튼누를 때
            password.isSecureTextEntry = true
            hideAndShowButton.image = UIImage(systemName: "eye.slash")
            Ptype = .hide
        }
    }
    
    // 둘러보기 버튼
    @IBAction func moveToMainPage(_ sender: Any) {
        let mainPageStoryBoard = UIStoryboard.init(name: "MainPage", bundle: nil)
        if let mainPage = mainPageStoryBoard.instantiateViewController(withIdentifier: "TapBarController") as? UITabBarController {
            mainPage.modalPresentationStyle = .fullScreen
            self.present(mainPage, animated: true, completion: nil)
        }
        
    }
    
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


