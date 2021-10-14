//
//  FindInfoViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/04.
//

import UIKit
import CryptoKit

struct FindID: Codable {
    let login_id: String?
}

class FindInfoViewController: UIViewController {

    @IBOutlet weak var emailForID: UITextField!
    @IBOutlet weak var emailForPW: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // 아이디 찾기 버튼
    @IBAction func findID(_ sender: Any) {
        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/user/find-id/") else {
            print("api is down")
            return
        }
        
        let email = emailForID.text!
        let param = ["email" : email]
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
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let findID = try decoder.decode(FindID.self, from: data)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "아이디 확인", message: findID.login_id, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } catch {
                    print("error")
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "아이디 확인 실패", message: "이메일을 정확하게 입력했는지 확인해주세요", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.resume()
    }
    
    // 비밀번호 찾기 버튼
    @IBAction func findPassWord(_ sender: Any) {
        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/user/dj-rest-auth/password/reset/") else {
            print("api is down")
            return
        }
        
        let email = emailForPW.text!
        let param = ["email" : email]
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

            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "비밀번호 변경을 위해 이메일을 확인해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }.resume()
    }
    
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
