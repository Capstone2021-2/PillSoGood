//
//  NutrientAnalysisViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/18.
//

import UIKit

class IntrinsicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let number = numberOfRows(inSection: 0)
        var height: CGFloat = 0

        for i in 0..<number {
            guard let cell = cellForRow(at: IndexPath(row: i, section: 0)) else {
                continue
            }
            height += cell.bounds.height
        }
        return CGSize(width: contentSize.width, height: height)
    }
}

class MySupplementSimpleCell: UITableViewCell {
    @IBOutlet weak var supplementLabel: UILabel!
    
}

class NutrientAnalysisViewController: UIViewController {

    @IBOutlet weak var supplementTableView: UITableView!
    @IBOutlet weak var suppTotalLabel: UILabel!
    @IBOutlet weak var viewForScroll: UIView!
    
    @IBOutlet weak var nutLabel: UILabel!   // 영양소 라벨
    @IBOutlet weak var amtLabel: UILabel!   // 섭취량 라벨
    @IBOutlet weak var appLabel: UILabel!   // 권장량 라벨
    
    var mySupplementInfo = [takingSupp]()
    var myNutrientInfo = [Int: nutrientInfo]()
    var nameLabelList = [UILabel]()
    
    var precautionNut = ["인삼", "프로바이오틱스", "알로에", "EPA와 DHA의 합", "밀크씨슬", "감마리놀렌산", "당귀", "돌외잎", "대두", "카르니틴", "녹차", "키토산", "스피루리나", "석류", "공액리놀레산", "클로렐라", "글루코사인", "가시오가피", "코엔자임", "은행", "쏘팔메토", "크랜베리", "포스파티딜레린"]
    var precuationButton: [UIButton]?
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        supplementTableView.rowHeight = 50
        
        Task {
            await getAsyncData()
            self.setNutrientInfo()
        }
    }
    
    func getAsyncData() async {
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.string(forKey: "pk")!
        try? await getAsyncSupplement(url: url)
        DispatchQueue.main.async {
            self.supplementTableView.reloadData()
            self.suppTotalLabel.text = "총 " + self.mySupplementInfo.count.description + "개"
        }
        
        for (_, item) in self.mySupplementInfo.enumerated() {
            let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/supplement_to_nutrient/" + item.supplement_pk.description
            try? await getAsyncURL(url: url2)
        }
    }
    
    func getAsyncSupplement(url: String) async throws {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!, delegate: .none)
        if let data = try? self.decoder.decode([takingSupp].self, from: data) {
            self.mySupplementInfo = data
        }
    }
    
    func getAsyncURL(url: String) async throws {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!, delegate: .none)
        
        if let data2 = try? self.decoder.decode([nutrientInfo].self, from: data) {
            for(_, item) in data2.enumerated() {
                if var temp = self.myNutrientInfo[item.nutrient] {
                    temp.amount += item.amount
                    continue
                }
                self.myNutrientInfo[item.nutrient] = item
            }
        }
        
    }
    
//    func getData() {
//        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.string(forKey: "pk")!
//        getRequest(url: url) { data in
//            if let data = try? self.decoder.decode([takingSupp].self, from: data!) {
//                self.mySupplementInfo = data
//                DispatchQueue.main.async {
//                    self.supplementTableView.reloadData()
//                    self.suppTotalLabel.text = "총 " + data.count.description + "개"
//                }
//                for (index, item) in data.enumerated() {
//                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/supplement_to_nutrient/" + item.supplement_pk.description
//                    getRequest(url: url2) { data2 in
//                        if let data2 = try? self.decoder.decode([nutrientInfo].self, from: data2!) {
//                            DispatchQueue.main.async {
//                                for (index2, item2) in data2.enumerated() {
//                                    if var temp = self.myNutrientInfo[item2.nutrient] {
//                                        temp.amount += item2.amount
//                                        continue
//                                    }
//                                    self.myNutrientInfo[item2.nutrient] = item2
//                                    if (index+1) == data.count && (index2+1) == data2.count {
//                                        print(index, index2)
//                                        self.setNutrientInfo()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func setNutrientInfo() {
        for (index, item) in myNutrientInfo.values.enumerated() {
            let nameLabel = UILabel()
            nameLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
            nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            nameLabel.lineBreakMode = .byWordWrapping
            nameLabel.numberOfLines = 0
            nameLabel.text = item.nutrient_name
            self.view.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let amountLabel = UILabel()
            amountLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
            amountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            amountLabel.text = item.amount.description + " /"
            self.view.addSubview(amountLabel)
            amountLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let appropriateAmountLabel = UILabel()
            let amountStr = item.lower.description + item.unit
            let attributedStr = NSMutableAttributedString(string: amountStr)
            attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 11, weight: .medium), range: (amountStr as NSString).range(of: item.unit))
            appropriateAmountLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
            appropriateAmountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            appropriateAmountLabel.attributedText = attributedStr
            self.view.addSubview(appropriateAmountLabel)
            appropriateAmountLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let appropriateLabel = UILabel()
            appropriateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            appropriateLabel.layer.masksToBounds = true
            appropriateLabel.layer.cornerRadius = 5
            if item.lower > item.amount {
                appropriateLabel.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 1.00)
                appropriateLabel.textColor = UIColor(red: 0.82, green: 0.74, blue: 0.51, alpha: 1.00)
                appropriateLabel.text = " 부족 "
            } else if item.upper < item.amount {
                appropriateLabel.backgroundColor = UIColor(red: 1.00, green: 0.59, blue: 0.60, alpha: 0.5)
                appropriateLabel.textColor = UIColor(red: 0.76, green: 0.45, blue: 0.47, alpha: 1.00)
                appropriateLabel.text = " 과다 "
            } else {
                appropriateLabel.backgroundColor = UIColor(red: 0.51, green: 0.69, blue: 0.97, alpha: 0.5)
                appropriateLabel.textColor = UIColor(red: 0.26, green: 0.40, blue: 0.57, alpha: 1.00)
                appropriateLabel.text = " 충분 "
            }
            self.view.addSubview(appropriateLabel)
            appropriateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            nameLabel.leadingAnchor.constraint(equalTo: viewForScroll.leadingAnchor, constant: 20).isActive = true
            amountLabel.rightAnchor.constraint(equalTo: amtLabel.rightAnchor).isActive = true
            appropriateAmountLabel.leftAnchor.constraint(equalTo: appLabel.leftAnchor).isActive = true
            appropriateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
            
            nameLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: 10).isActive = true
            
            nameLabel.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: appropriateAmountLabel.centerYAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: appropriateLabel.centerYAnchor).isActive = true
            
            if index == 0 {
                nameLabel.topAnchor.constraint(equalTo: nutLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                nameLabel.topAnchor.constraint(equalTo: nameLabelList[index-1].bottomAnchor, constant: 10).isActive = true
            }
            nameLabelList.append(nameLabel)
        }
        setPrecautions()
    }
    
    func setPrecautions() {
        let precautionLabel = UILabel()
        precautionLabel.textColor = UIColor(red: 255/255, green: 98/255, blue: 98/255, alpha: 1)
        precautionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        precautionLabel.text = "의약품과 병용섭취 시 주의사항"
        self.view.addSubview(precautionLabel)
        precautionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        precautionLabel.topAnchor.constraint(equalTo: (nameLabelList.last?.bottomAnchor ?? nutLabel.bottomAnchor), constant: 30).isActive = true
        precautionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        for (_, item) in myNutrientInfo.enumerated() {
            for nut in precautionNut {
                if item.value.nutrient_name.contains(nut) {
                    let preView = UIButton()
                    preView.setTitle(item.value.nutrient_name, for: .normal)
                    preView.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
                    preView.backgroundColor = UIColor(red: 1, green: 98/255, blue: 86/255, alpha: 0.3)
                    preView.cornerRadius = 10
                    preView.setTitleColor(UIColor(red: 184/255, green: 70/255, blue: 63/255, alpha: 1), for: .normal)
                    self.view.addSubview(preView)
                    preView.translatesAutoresizingMaskIntoConstraints = false

                    if precuationButton?.last == nil {
                        precuationButton = [UIButton]()
                        preView.topAnchor.constraint(equalTo: precautionLabel.bottomAnchor, constant: 20).isActive = true
                    } else {
                        preView.topAnchor.constraint(equalTo: precuationButton!.last!.bottomAnchor, constant: 10).isActive = true
                    }
                    preView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                    preView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

                    preView.addTarget(self, action: #selector(nutrientPrecaution), for: .touchUpInside)
                    precuationButton?.append(preView)
                    break
                }
            }
        }
        
    }
    
    @objc func nutrientPrecaution(_ sender : UIButton) {
        let alertVC = self.storyboard!.instantiateViewController(withIdentifier: "PrecautionViewController") as! PrecautionViewController
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.Nutname = sender.currentTitle
        self.present(alertVC, animated: true, completion: nil)
    }

}

extension NutrientAnalysisViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySupplementInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySupplementSimpleCell", for: indexPath) as! MySupplementSimpleCell
        cell.supplementLabel.text = mySupplementInfo[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
