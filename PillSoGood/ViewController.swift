//
//  ViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/09/28.
//

import UIKit
import CryptoKit

enum PasswordType {
    case show
    case hide
}

struct Response: Codable {
    let success: Bool?
    let token: String?
    let message: String?
    let login_id: String?
    let email: String?
    let nickname: String?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var id: UITextField! // 아이디
    @IBOutlet weak var password: UITextField!   // 비밀번호
    @IBOutlet weak var hideAndShowButton: UIImageView! {
        didSet {
            hideAndShowButton.isUserInteractionEnabled = true
            hideAndShowButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType)))
        }
    }
    var Ptype = PasswordType.hide
    
    @IBOutlet weak var loginButton: UIButton! { // 로그인 버튼
        didSet {
            loginButton.layer.cornerRadius = 5
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = UserDefaults.standard.string(forKey: "token") {
            self.moveToMain()
        }
    }
    
    // 로그인 버튼
    @IBAction func logIn(_ sender: Any) {
        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/user/login") else {
            print("api is down")
            return
        }
        
        let login_id = self.id.text!
        let password = self.password.text?.data(using: .utf8)!
        let passwordSHA = SHA256.hash(data: password!)
        let hashString = passwordSHA.compactMap { String(format: "%02x", $0) }.joined()
        let param = ["login_id" : login_id, "password" : hashString]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let e = error {
                print(e.localizedDescription)
            }
            guard let data = data else {
                        print("Error: Did not receive data")
                        return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Response.self, from: data)
                if result.success == nil {  // 로그인 실패 시
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: nil, message: "아이디 및 비밀번호를 확인해주세요", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {    // 로그인 성공 시
                    DispatchQueue.main.async {
                        self.moveToMain()
                    }
                    UserDefaults.standard.set(login_id, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "pw")
                    UserDefaults.standard.set(result.token, forKey: "token")
                    UserDefaults.standard.set(result.email, forKey: "email")
                    UserDefaults.standard.set(result.nickname, forKey: "nickname")
                }
            } catch {
                print("error")
            }
        }.resume()
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
        moveToMain()
    }
    
    func moveToMain() {
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


