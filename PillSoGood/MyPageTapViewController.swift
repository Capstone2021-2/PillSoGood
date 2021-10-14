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
            profileImage.layer.cornerRadius = 35
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
