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
    @IBOutlet weak var alarmImageView: UIImageView!
    @IBOutlet weak var alarmLabel: UILabel!
    
}

class AlarmTapViewController: UIViewController {

    @IBOutlet weak var mySupplementTableView: UITableView!
    
    var mySupplements = [MySupplement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "token") == nil {
            let alertVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginAlertViewController") as! LoginAlertViewController
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: true, completion: nil)
        }
        
        self.navigationItem.title = "나의 복용 제품"
        if let temp = UserDefaults.standard.value(forKey: "MySupplements") as? Data {
            mySupplements = try! PropertyListDecoder().decode([MySupplement].self, from: temp)
            getAdditionalData()
        } else {
            getData()
        }
        mySupplementTableView.dataSource = self
        mySupplementTableView.delegate = self
    }
    
    func getAdditionalData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.integer(forKey: "pk").description
        getRequest(url: url) { data in
            if let data = try? decoder.decode([takingSupp].self, from: data!) {
                for item in data {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + item.supplement_pk.description
                    getRequest(url: url2) { data2 in
                        DispatchQueue.main.async {
                            if let data2 = try? decoder.decode(supplement.self, from: data2!) {
                                var count = 0
                                for item in self.mySupplements {
                                    if item.pk != data2.pk {
                                        count += 1
                                    }
                                }
                                if count == self.mySupplements.count {
                                    self.mySupplements.append(MySupplement(pk: data2.pk, name: data2.name, brand: data2.company, imageUrl: "", useAlarm: 0, alarms: nil, uuid: nil))
                                    self.mySupplementTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.integer(forKey: "pk").description
        getRequest(url: url) { data in
            if let data = try? decoder.decode([takingSupp].self, from: data!) {
                for item in data {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + item.supplement_pk.description
                    getRequest(url: url2) { data2 in
                        DispatchQueue.main.async {
                            if let data2 = try? decoder.decode(supplement.self, from: data2!) {
                                self.mySupplements.append(MySupplement(pk: data2.pk, name: data2.name, brand: data2.company, imageUrl: "", useAlarm: 0, alarms: nil, uuid: nil))
                                self.mySupplementTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // 플러스 버튼 클릭 시
    @IBAction func addSupplement(_ sender: Any) {
        
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        getAdditionalData()
        self.navigationController?.tabBarItem.title = "내 영양제"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(mySupplements), forKey: "MySupplements")
        self.navigationController?.tabBarItem.title = nil
    }

}

extension AlarmTapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySupplements.count
    }
    
    // tableViewCell 클릭 시 AlarmDetailViewController로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let alarmVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(identifier: "AlarmDetailViewController") as? AlarmDetailViewController {
            alarmVC.title = "알람 설정"
            alarmVC.supplementInfo = mySupplements[indexPath.row]
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
            alarmVC.supplementClosure = { sup in
                self.mySupplements[indexPath.row] = sup
                tableView.reloadData()
            }

            self.navigationController?.pushViewController(alarmVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySupplementCell", for: indexPath) as! MySupplementCell
        let supplement = mySupplements[indexPath.row]
        
        cell.supplementLabel.text = supplement.name
        cell.brandLabel.text = supplement.brand
        if supplement.useAlarm == 1 {
            cell.alarmImageView.image = UIImage(systemName: "bell.circle")
            var label = ""
            for index in 0..<supplement.alarms!.count {
                label += supplement.alarms![index] + " "
            }
            cell.alarmLabel.text = label
        } else {
            cell.alarmImageView.image = UIImage(systemName: "bell.slash.circle")
            cell.alarmLabel.text = ""
        }
        
        return cell
    }
    
    // tableView Cell 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    // 스와이프해서 tableView Cell 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeItem = mySupplements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let user_pk = UserDefaults.standard.integer(forKey: "pk").description
            let accessToken = "jwt " + UserDefaults.standard.string(forKey: "token")!
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/delete/" + user_pk + "/" + removeItem.pk.description
            deleteRequest(url: url, accessToken: accessToken) { data in
            }
        }
    }
    
    // 스와이프 코멘트 "Delete"에서 "삭제"로 변경
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }


}
