//
//  FindInfoViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/04.
//

import UIKit

class FindInfoViewController: UIViewController {

    @IBOutlet weak var emailForID: UITextField!
    @IBOutlet weak var emailForPW: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // 아이디 찾기 버튼
    @IBAction func findID(_ sender: Any) {
        
    }
    
    // 비밀번호 찾기 버튼
    @IBAction func findPassWord(_ sender: Any) {
        
    }
    
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
