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
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        supplementTableView.rowHeight = 50
        
        getData()
    }
    
//    func getAsyncData() async throws -> Void {
//        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.string(forKey: "pk")!
//        let (data, response) = try await URLSession.shared.dataTask(with: URL(string: url))
//
//    }
    
    func getData() {
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.string(forKey: "pk")!
        getRequest(url: url) { data in
            if let data = try? self.decoder.decode([takingSupp].self, from: data!) {
                self.mySupplementInfo = data
                DispatchQueue.main.async {
                    self.supplementTableView.reloadData()
                    self.suppTotalLabel.text = "총 " + data.count.description + "개"
                }
                for (index, item) in data.enumerated() {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/supplement_to_nutrient/" + item.supplement_pk.description
                    getRequest(url: url2) { data2 in
                        if let data2 = try? self.decoder.decode([nutrientInfo].self, from: data2!) {
                            DispatchQueue.main.async {
                                for (index2, item2) in data2.enumerated() {
                                    if var temp = self.myNutrientInfo[item2.nutrient] {
                                        temp.amount += item2.amount
                                        continue
                                    }
                                    self.myNutrientInfo[item2.nutrient] = item2
                                    if (index+1) == data.count && (index2+1) == data2.count {
                                        self.setNutrientInfo()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
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
