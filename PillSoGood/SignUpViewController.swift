//
//  SignUpViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/03.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    var Ptype = PasswordType.hide
    @IBOutlet weak var hideAndShowButton: UIImageView! {
        didSet {
            hideAndShowButton.isUserInteractionEnabled = true
            hideAndShowButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPasswordType)))
        }
    }
    
    @IBOutlet weak var email: UITextField!  // 이메일
    @IBOutlet weak var age: UITextField!    // 나이대
    @IBOutlet weak var weight: UITextField! // 몸무게
    @IBOutlet weak var height: UITextField! // 키
    @IBOutlet weak var habitus: UITextField!    // 체질
    
    let emailPickerView = UIPickerView()
    let agePickerView = UIPickerView()
    let habitusPickerView = UIPickerView()
    
    let emails = ["naver.com", "daum.net", "gmail.com"]
    let ages = ["1~2세", "3~5세", "6~8세", "9~11세", "12~14세", "15~18세", "19~29세", "30~49세", "50~64세", "65~74세", "75세 이상"]
    let habituses = ["선택안함", "열태양", "한태양", "열소음", "한소음", "열소양", "한소양", "열태음", "한태음"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingKeyboard()
        createPickerView()
        dismissPickerView()
    }
    
    // 키보드에의해 텍스트필드 가려지는 문제 -> 수정 필요
    func settingKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(noti: NSNotification) {
//        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y -= keyboardHeight
//        }
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(noti: NSNotification) {
//        if self.view.frame.origin.y != 0.0 {
//            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                let keyboardRectangle = keyboardFrame.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
//                self.view.frame.origin.y += keyboardHeight
//            }
//        }
        self.view.frame.origin.y = 0
    }
    
    // picker view 연결
    func createPickerView() {
        email.text = emails[0]
        email.tintColor = .clear
        
        emailPickerView.delegate = self
        email.inputView = emailPickerView
        
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
        
        email.inputAccessoryView = toolBar
        age.inputAccessoryView = toolBar
        habitus.inputAccessoryView = toolBar
    }
    
    @objc func pickerExit() {
        self.view.endEditing(true)
    }
    
    // 시작하기 버튼을 누를 시
    @IBAction func dismissSignUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            email.text = emails[row]
        } else if pickerView == agePickerView {
            age.text = ages[row]
        } else {
            habitus.text = habituses[row]
        }
    }
}
