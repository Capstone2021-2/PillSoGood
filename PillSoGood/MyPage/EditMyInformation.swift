//
//  EditMyInformation.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/26.
//

import UIKit
import CryptoKit

class EditMyInformation: UIViewController {
    
    @IBOutlet weak var userId: UITextField! // 아이디
    @IBOutlet weak var password: UITextField!   // 패스워드
    @IBOutlet weak var showPassword1: UIButton! // 눈 버튼
    @IBOutlet weak var checkPassword: UITextField!  // 패스워드 확인
    @IBOutlet weak var showPassword2: UIButton! // 눈 버튼
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var userNickname: UITextField!   // 닉네임
    @IBOutlet weak var userEmail: UITextField!    // 이메일 아이디
    @IBOutlet weak var userGender: UISegmentedControl!  // 성별
    @IBOutlet weak var userAge: UITextField!    // 나이대
    @IBOutlet weak var userConstitution: UITextField!   // 체질
    
    let agesPickerView = UIPickerView()
    let constitutionPickerView = UIPickerView()
    
    let ages = ["선택안함", "6~8세", "9~11세", "12~14세", "15~18세", "19~29세", "30~49세", "50~64세", "65~74세", "75세 이상"]
    let constitutions = ["선택안함", "열태양", "한태양", "열소음", "한소음", "열소양", "한소양", "열태음", "한태음"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButtonItem = UIBarButtonItem(title: "수정", style: .done, target: self, action: #selector(editingFinish))
        rightBarButtonItem.tintColor = .lightGray
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.isNavigationBarHidden = false
        
        if let id = UserDefaults.standard.string(forKey: "id") {
            self.userId.text = id
        }
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            self.userNickname.text = nickname
        }
        if let email = UserDefaults.standard.string(forKey: "email") {
            self.userEmail.text = email
        }
        
        checkPassword.addTarget(self, action: #selector(confirmPassword), for: .editingChanged)
        password.addTarget(self, action: #selector(confirmPassword), for: .editingChanged)
        
        createPickerView()
    }
    
    // 네비게이션바 수정 버튼 클릭 시
    @objc func editingFinish() {
        var param = [String:Any]()
        if password.text?.isEmpty == false {
            if confirmLabel.text == "확인되었습니다" && password.text!.count >= 8 {
                let pw = self.password.text?.data(using: .utf8)!
                let pwSHA = SHA256.hash(data: pw!)
                let hashString = pwSHA.compactMap { String(format: "%02x", $0) }.joined()
                param["password"] = hashString
            } else {
                let alert = UIAlertController(title: nil, message: "비밀번호를 확인해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if let nickname = userNickname {
            param["nickname"] = nickname.text
        }
        
        let gender = userGender.selectedSegmentIndex
        switch gender {
        case 0:
            param["gender"] = ""
        case 1:
            param["gender"] = "여성"
        case 2:
            param["gender"] = "남성"
        default: break
        }
        
        if userAge.text == "선택안함" {
            param["age"] = ""
        } else {
            param["age"] = userAge.text
        }
        
        if userConstitution.text == "선택안함" {
            param["constitution"] = ""
        } else {
            param["constitution"] = userConstitution.text
        }
        
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

        URLSession.shared.dataTask(with: request) { Data, Response, Error in
            if let error = Error {
                print(error)
                return
            }
        }.resume()
    }
    
    @objc func confirmPassword(sender: UITextField) {
        if checkPassword.text == password.text {
            checkPassword.layer.borderWidth = 0
            confirmLabel.textColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1)
            confirmLabel.text = "확인되었습니다"
        } else {
            checkPassword.layer.borderWidth = 0.5
            checkPassword.layer.borderColor = UIColor.red.cgColor
            checkPassword.layer.cornerRadius = 5
            confirmLabel.textColor = .red
            confirmLabel.text = "비밀번호가 다릅니다"
        }
    }
    
    // 눈 모양버튼 클릭 시
    @IBAction func showPassword(_ sender: UIButton) {
        if sender == showPassword1 {
            if password.isSecureTextEntry == true {
                password.isSecureTextEntry = false
                showPassword1.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                password.isSecureTextEntry = true
                showPassword1.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        } else {
            if checkPassword.isSecureTextEntry == true {
                checkPassword.isSecureTextEntry = false
                showPassword2.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                checkPassword.isSecureTextEntry = true
                showPassword2.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
    }
    
    
    // picker view 연결
    func createPickerView() {
        userAge.text = ages[0]
        userAge.tintColor = .clear
        agesPickerView.delegate = self
        userAge.inputView = agesPickerView
        
        userConstitution.text = constitutions[0]
        userConstitution.tintColor = .clear
        constitutionPickerView.delegate = self
        userConstitution.inputView = constitutionPickerView
        
        dismissPickerView()
    }
    
    // picker view 툴바
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(pickerExit))
        toolBar.setItems([flexSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        userAge.inputAccessoryView = toolBar
        userConstitution.inputAccessoryView = toolBar
    }
    
    @IBAction func moveToSurvey(_ sender: Any) {
        if let surveyVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "SurveyViewController") as? SurveyViewController {
            surveyVC.title = "체질 검사"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.pushViewController(surveyVC, animated: true)
        }
    }
    
    
    @objc func pickerExit() {
        self.view.endEditing(true)
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// picker extension 정의
extension EditMyInformation: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    // 몇 개의 선택 가능한 리스트를 표시할 지
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // picker view에 표시될 항목의 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agesPickerView {
            return ages.count
        } else {
            return constitutions.count
        }
    }
    
    // picker view 내에서 특정한 위치를 가리킬 때, 그 위치에 해당하는 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agesPickerView {
            return ages[row]
        } else {
            return constitutions[row]
        }
    }
    
    // 텍스트필드의 텍스트를 선택된 특정 row의 문자열로 바꾸기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == agesPickerView {
            userAge.text = ages[row]
        } else {
            userConstitution.text = constitutions[row]
        }
    }
}
