//
//  AlarmDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/08.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    
}

class AlarmDetailViewController: UIViewController {
    
    @IBOutlet weak var supplementImageView: UIImageView!    // 영양제 사진
    @IBOutlet weak var supplementLabel: UILabel!    // 영양제 이름
    @IBOutlet weak var brandLabel: UILabel! // 영양제 브랜드

    @IBOutlet weak var alarmSwitch: UISwitch!   // 알람 스위치
    @IBOutlet weak var alarmAddButton: UIButton!    // 추가 버튼
    @IBOutlet weak var alarmTableView: UITableView! // 알람 테이블뷰
    
    var alarm = [UIDatePicker]()   // 알람 수(수정 필요)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = false
        
        setAlarmSwitch()
    }
    
    func setAlarmSwitch() {
        alarmSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.75)
        alarmSwitch.setOn(false, animated: false)
    }
    
    // 뒤로갈 때 네비게이션바 없애기
    override func viewWillDisappear(_ animated: Bool) {
//        let fommater = DateFormatter()
//        fommater.dateFormat = "HH:mm"
//        for i in alarm {
//            print(fommater.string(from: i.date))
//        }
        UserDefaults.standard.set(alarm, forKey: "alarmsetting")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // 복용알림 스위치 누를 시
    @IBAction func clickSwitchButton(_ sender: Any) {
        
        if alarmSwitch.isOn {
            alarmAddButton.isHidden = false
            addAlarm(sender)

        } else {
            alarmAddButton.isHidden = true
            alarm.removeAll()
            alarmTableView.reloadData()
        }
    }
    
    // 알람 추가 버튼
    @IBAction func addAlarm(_ sender: Any) {
        alarm.append(UIDatePicker())
        alarmTableView.reloadData()
    }
    
}

extension AlarmDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        cell.alarmLabel.text = "알람" + (indexPath.row+1).description
        cell.selectionStyle = .none
        alarm[indexPath.row] = cell.alarmTimePicker
        
        return cell
    }
    
    // tableView Cell 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 스와이프해서 tableView Cell 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alarm.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 스와이프 코멘트 "Delete"에서 "삭제"로 변경
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}


