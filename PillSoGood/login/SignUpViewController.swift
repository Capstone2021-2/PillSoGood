//
//  SignUpViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/03.
//

import UIKit
import CryptoKit

class SignUpViewController: UIViewController {
    
    struct DuplicateId: Codable {
        let isValid: Int
    }

    @IBOutlet weak var userId: UITextField! // 아이디
    @IBOutlet weak var password: UITextField!   // 패스워드
    var Ptype = PasswordType.hide
    @IBOutlet weak var hideAndShowButton: UIImageView! {
        didSet {
            hideAndShowButton.isUserInteractionEnabled = true
            hideAndShowButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType)))
        }
    }
    @IBOutlet weak var checkPassword: UITextField!  // 패스워드 확인
    var isChecked = 0
    @IBOutlet weak var checkPasswordLabel: UILabel! // 패스워드 확인 label
    var Ptype2 = PasswordType.hide
    @IBOutlet weak var hideAndShowButton2: UIImageView! {
        didSet {
            hideAndShowButton2.isUserInteractionEnabled = true
            hideAndShowButton2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType2)))
        }
    }
    @IBOutlet weak var nickname: UITextField!   //닉네임
    @IBOutlet weak var emailId: UITextField!    // 이메일아이디
    @IBOutlet weak var emailAddress: UITextField!  // 이메일주소
    @IBOutlet weak var duplicationButton: UIButton! // 중복확인 버튼
    
    let emailPickerView = UIPickerView()
    let emails = ["naver.com", "daum.net", "gmail.com", "nate.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        dismissPickerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pwTextFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: password)
        NotificationCenter.default.addObserver(self, selector: #selector(checkPasswordDidChange), name: UITextField.textDidChangeNotification, object: checkPassword)
        NotificationCenter.default.addObserver(self, selector: #selector(nnTextFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nickname)

    }
    
    // 아이디 중복확인 버튼
    @IBAction func confirmDuplication(_ sender: Any) {
        let login_id = userId.text!
        let param = ["login_id": login_id]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/user/duplicate-id") else {
            print("api is down")
            return
        }

        // URLRequest 객체 정의
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")

        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print("An error has occured: \(err.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let isDuplicate = try decoder.decode(DuplicateId.self, from: data)
                    DispatchQueue.main.async {
                        if isDuplicate.isValid == 1 {
                            let alert = UIAlertController(title: "사용 가능", message: "아이디 사용이 가능합니다.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                                self.duplicationButton.isEnabled = false
                                self.userId.isEnabled = false
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "사용 불가능", message: "다른 아이디를 입력해주세요", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } catch {
                    print("error")
                }
            }
            
            print(response!)
        }.resume()  // POST 전송!
    }
    
    // 패스워드 textfield 8자 이하 빨간줄 표시
    @objc func pwTextFieldDidChange(_ notification: Notification) {
        if let password = notification.object as? UITextField {
            if let text = password.text {
                if text.count < 8 {
                    self.password.layer.borderWidth = 0.5
                    self.password.layer.borderColor = UIColor.red.cgColor
                    self.password.layer.cornerRadius = 5
                } else {
                    self.password.layer.borderWidth = 0
                }
            }
        }
    }
    
    @objc func checkPasswordDidChange(_ notification: Notification) {
        if let checkPassword = notification.object as? UITextField {
            if let text = checkPassword.text {
                if text == password.text {
                    self.checkPasswordLabel.text = "확인되었습니다"
                    self.checkPasswordLabel.textColor = .darkGray
                    self.checkPassword.layer.borderWidth = 0
                    self.isChecked = 1
                } else {
                    self.checkPassword.layer.borderWidth = 0.5
                    self.checkPassword.layer.borderColor = UIColor.red.cgColor
                    self.checkPassword.layer.cornerRadius = 5
                    self.checkPasswordLabel.textColor = .red
                    self.checkPasswordLabel.text = "비밀번호가 다릅니다"
                    self.isChecked = 0
                }
            }
        }
    }
    
    // 닉네임 textfield 10자 이상 빨간줄 표시
    @objc func nnTextFieldDidChange(_ notification: Notification) {
        if let nickname = notification.object as? UITextField {
            if let text = nickname.text {
                if text.count > 10 {
                    self.nickname.layer.borderWidth = 0.5
                    self.nickname.layer.borderColor = UIColor.red.cgColor
                    self.nickname.layer.cornerRadius = 5
                } else {
                    self.nickname.layer.borderWidth = 0
                }
            }
        }
    }
    
    // picker view 연결
    func createPickerView() {
        emailAddress.text = emails[0]
        emailAddress.tintColor = .clear
        
        emailPickerView.delegate = self
        emailAddress.inputView = emailPickerView
    }
    
    // picker view 툴바
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(pickerExit))
        toolBar.setItems([flexSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        emailAddress.inputAccessoryView = toolBar
    }
    
    @objc func pickerExit() {
        self.view.endEditing(true)
    }
    
    // 필수정보가 입력되었는 지 확인
    func checkRequiredInfo() -> String {
        if duplicationButton.isEnabled {
            return "아이디 중복확인을 해주세요"
        } else if password.text!.count < 8 {
            return "비밀번호를 8자리 이상으로 설정해주세요"
        } else if isChecked == 0 {
            return "비밀번호를 확인해주세요"
        } else if nickname.text!.count > 10 {
            return "닉네임을 10자리 이하로 설정해주세요"
        } else if emailId.text!.isEmpty {
            return "이메일을 입력해주세요"
        } else {
            return ""
        }
    }
    
    // 시작하기 버튼을 누를 시
    @IBAction func dismissSignUp(_ sender: Any) {
        let message = checkRequiredInfo()
        if message == "" {
            // 전송할 값 : id, password, nickname, email
            let login_id = self.userId.text!
            let password = self.password.text?.data(using: .utf8)!
            let passwordSHA = SHA256.hash(data: password!)
            let hashString = passwordSHA.compactMap { String(format: "%02x", $0) }.joined()
            let nickname = self.nickname.text!
            let email = self.emailId.text! + "@" + self.emailAddress.text!
            
            let param = ["login_id": login_id, "password": hashString, "nickname": nickname, "email": email]
            let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

            guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/user/signup") else {
                print("api is down")
                return
            }

            // URLRequest 객체 정의
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = paramData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")

            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                if let err = error {
                    print("An error has occured: \(err.localizedDescription)")
                    return
                }
                print(response!)
            }.resume()  // POST 전송!

            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // 비밀번호 옆 눈 모양 버튼을 누를 시
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
    
    // 비밀번호 확인 옆 눈 모양 버튼을 누를 시
    @objc func selectPasswordType2() {
        if Ptype2 == .hide { // 비밀번호 숨김 상태에서 버튼누를 때
            checkPassword.isSecureTextEntry = false
            hideAndShowButton2.image = UIImage(systemName: "eye")
            Ptype2 = .show
        } else {    // 비밀번호 보임 상태에서 버튼누를 때
            checkPassword.isSecureTextEntry = true
            hideAndShowButton2.image = UIImage(systemName: "eye.slash")
            Ptype2 = .hide
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

// picker extension 정의
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // 몇 개의 선택 가능한 리스트를 표시할 지
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // picker view에 표시될 항목의 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emails.count
    }
    
    // picker view 내에서 특정한 위치를 가리킬 때, 그 위치에 해당하는 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return emails[row]
    }
    
    // 텍스트필드의 텍스트를 선택된 특정 row의 문자열로 바꾸기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        emailAddress.text = emails[row]
    }
}
