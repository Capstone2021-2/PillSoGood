//
//  AlarmTapViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/05.
//

import UIKit

class MySupplementCell: UITableViewCell {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
}

class AlarmTapViewController: UIViewController {

    @IBOutlet weak var mySupplementTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySupplementTableView.dataSource = self
        mySupplementTableView.delegate = self
        
    }
    
    
    // 플러스 버튼 클릭 시
    @IBAction func addSupplement(_ sender: Any) {
        
    }
    
    
    // 쓰레기통 버튼 클릭 시
    @IBAction func removeSupplement(_ sender: Any) {
        
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "내 영양제"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = nil
    }

}

extension AlarmTapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // tableViewCell 클릭 시 AlarmDetailViewController로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let alarmVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(identifier: "AlarmDetailViewController") as? AlarmDetailViewController {
            alarmVC.title = "알람 설정"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem

            self.navigationController?.pushViewController(alarmVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySupplementCell", for: indexPath) as! MySupplementCell
        
        cell.supplementLabel.text = "지웨이 알티지 오메가3"
        cell.brandLabel.text = "지웨이"
        
        return cell
    }
    
    // tableView Cell 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    // 스와이프해서 tableView Cell 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 스와이프 코멘트 "Delete"에서 "삭제"로 변경
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }


}
