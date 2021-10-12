//
//  SignUpViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/03.
//

import UIKit
import CryptoKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userId: UITextField! // 아이디
    @IBOutlet weak var password: UITextField!   // 패스워드
    var Ptype = PasswordType.hide
    @IBOutlet weak var hideAndShowButton: UIImageView! {
        didSet {
            hideAndShowButton.isUserInteractionEnabled = true
            hideAndShowButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType)))
        }
    }
    @IBOutlet weak var nickname: UITextField!   //닉네임
    @IBOutlet weak var emailId: UITextField!    // 이메일아이디
    @IBOutlet weak var emailAddress: UITextField!  // 이메일주소
    
    @IBOutlet weak var gender: UISegmentedControl!  // 성별
    @IBOutlet weak var age: UITextField!    // 나이대
    @IBOutlet weak var weight: UITextField! // 몸무게
    @IBOutlet weak var height: UITextField! // 키
    @IBOutlet weak var habitus: UITextField!    // 체질
    
    @IBOutlet weak var duplicationButton: UIButton!
    
    let emailPickerView = UIPickerView()
    let agePickerView = UIPickerView()
    let habitusPickerView = UIPickerView()
    
    let emails = ["naver.com", "daum.net", "gmail.com", "nate.com"]
    let ages = ["1~2세", "3~5세", "6~8세", "9~11세", "12~14세", "15~18세", "19~29세", "30~49세", "50~64세", "65~74세", "75세 이상"]
    let habituses = ["선택안함", "열태양", "한태양", "열소음", "한소음", "열소양", "한소양", "열태음", "한태음"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        dismissPickerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pwTextFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: password)
        NotificationCenter.default.addObserver(self, selector: #selector(nnTextFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nickname)

    }
    
    // 아이디 중복확인 버튼
    @IBAction func confirmDuplication(_ sender: Any) {
        if true {   // 아이디 사용 가능하면
            // db 확인~~
            let alert = UIAlertController(title: "사용 가능", message: "아이디 사용이 가능합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                self.duplicationButton.isEnabled = false
                self.userId.isEnabled = false
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {    // 아이디 사용 불가능하면
            let alert = UIAlertController(title: "사용 불가능", message: "다른 아이디를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
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
        
        age.text = ages[0]
        age.tintColor = .clear
        
        agePickerView.delegate = self
        age.inputView = agePickerView
        
        habitus.text = habituses[0]
        habitus.tintColor = .clear
        
        habitusPickerView.delegate = self
        habitus.inputView = habitusPickerView
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
        age.inputAccessoryView = toolBar
        habitus.inputAccessoryView = toolBar
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
        if pickerView == emailPickerView {
            return emails.count
        } else if pickerView == agePickerView {
            return ages.count
        } else {
            return habituses.count
        }
    }
    
    // picker view 내에서 특정한 위치를 가리킬 때, 그 위치에 해당하는 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == emailPickerView {
            return emails[row]
        } else if pickerView == agePickerView {
            return ages[row]
        } else {
            return habituses[row]
        }
    }
    
    // 텍스트필드의 텍스트를 선택된 특정 row의 문자열로 바꾸기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == emailPickerView {
            emailAddress.text = emails[row]
        } else if pickerView == agePickerView {
            age.text = ages[row]
        } else {
            habitus.text = habituses[row]
        }
    }
}
