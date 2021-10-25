//
//  AlarmDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/08.
//

import UIKit
import UserNotifications

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
    
    var supplementInfo: MySupplement!
    var alarm = [UIDatePicker]()
    var supplementClosure: ((MySupplement) -> Void)?
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supplementLabel.text = supplementInfo.name
        self.brandLabel.text = supplementInfo.brand
        alarmSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.75)
        if self.supplementInfo.useAlarm == 1 {
            alarmAddButton.isHidden = false
            alarmSwitch.setOn(true, animated: false)
            for index in 0..<supplementInfo.alarms!.count {
                let datePicker = UIDatePicker()
                datePicker.date = stringToDateType(string: supplementInfo.alarms![index])
                alarm.append(datePicker)
                alarmTableView.reloadData()
            }
        } else {
            alarmSwitch.setOn(false, animated: false)
        }
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 뒤로갈 때 네비게이션바 없애기
    override func viewWillDisappear(_ animated: Bool) {
        saveAlarmData()
        if supplementInfo.useAlarm == 1 {
            registerNotification()
        } else {
            removeNotification()
        }
        supplementClosure?(supplementInfo)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func saveAlarmData() {
        supplementInfo.useAlarm = alarmSwitch.isOn == true ? 1 : 0
        if alarmSwitch.isOn {
            supplementInfo.alarms = [String]()
            for index in 0..<alarm.count {
                supplementInfo.alarms!.append(dateToStringType(date: alarm[index].date))
            }
        } else {
            supplementInfo.alarms = nil
        }
    }
    
    // 복용알림 스위치 누를 시
    @IBAction func clickSwitchButton(_ sender: Any) {
        
        if alarmSwitch.isOn {
            alarmAddButton.isHidden = false
            addAlarm(sender)

        } else {
            alarmAddButton.isHidden = true
            alarm.removeAll()
            supplementInfo.alarms?.removeAll()
            alarmTableView.reloadData()
        }
    }
    
    // 알람 추가 버튼
    @IBAction func addAlarm(_ sender: Any) {
        alarm.append(UIDatePicker())
        alarmTableView.reloadData()
    }
    
    func removeNotification() {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: supplementInfo.uuid ?? [])
        supplementInfo.uuid?.removeAll()
    }
    
    // 알람 등록
    func registerNotification() {
        removeNotification()
        
        let content = UNMutableNotificationContent()
        content.title = "지금은 " + supplementInfo.name + " 복용시간!"
        content.body = supplementInfo.name + " 복용시간입니다. 건강을 위해 챙겨먹어요 :)"
        
        for index in 0..<supplementInfo.alarms!.count {
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: stringToDateType(string: supplementInfo.alarms![index])), repeats: true)
            
            let identifier = UUID().uuidString
            supplementInfo.uuid?.append(identifier)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            notificationCenter.add(request) { Error in
                if let error = Error {
                    print(error)
                }
            }
        }
        
    }
    
    func stringToDateType(string : String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: string)!
    }
    
    func dateToStringType(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
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
        if supplementInfo.useAlarm == 1 {
            cell.alarmTimePicker.date = alarm[indexPath.row].date
        }
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
            supplementInfo.alarms?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 스와이프 코멘트 "Delete"에서 "삭제"로 변경
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}


