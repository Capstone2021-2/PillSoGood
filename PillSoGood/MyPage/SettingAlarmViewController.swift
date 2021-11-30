//
//  SettingAlarmViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/30.
//

import UIKit

class SettingAlarmViewController: UIViewController {

    @IBOutlet weak var switchControl: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isPush = UIApplication.shared.isRegisteredForRemoteNotifications
        print(isPush)
        
        if isPush {
            switchControl.setOn(true, animated: false)
        } else {
            switchControl.setOn(false, animated: false)
        }
    }
    
    @IBAction func setAlarm(_ sender: UISwitch) {
        if sender.isOn {
            if switchControl.isOn && !UIApplication.shared.isRegisteredForRemoteNotifications {
                let alert = UIAlertController(title: "알림 권한을 활성화 해주세요.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { action in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                // notification 등록된 알림 일괄 삭제
            }
        }
    }
    
    @IBAction func closeAlertView(_ sender: Any) {
        if switchControl.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
        self.dismiss(animated: true, completion: nil)
    }

}
