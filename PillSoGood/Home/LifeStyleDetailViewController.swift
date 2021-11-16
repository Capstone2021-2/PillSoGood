//
//  LifeStyleDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class LifeStyleDetailViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalSuppLabel: UILabel!
    @IBOutlet weak var supplementTableView: UITableView!
    
    var supplementList = [supplement]()
    var nutrients = [goodForLifeStyle]()
    var lifeStyle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        supplementTableView.register(UINib(nibName: "SupplementCell", bundle: nil), forCellReuseIdentifier: "SupplementCell")
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        
        getNutrientData()
        getSupplementData()
        
    }
    
    func setDescriptionLabel(str: String) {
        let desLabel = lifeStyle! + "에 좋은 영양소는\n" + str + "입니다.\n아래에서 해당 영양소가 포함된 영양제를 확인하세요:)"
        let fontSize = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let attributedStr = NSMutableAttributedString(string: desLabel)
        attributedStr.addAttribute(.font, value: fontSize, range: (desLabel as NSString).range(of: self.lifeStyle!))
        attributedStr.addAttribute(.font, value: fontSize, range: (desLabel as NSString).range(of: str))
        attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 0.92, green: 0.59, blue: 0.58, alpha: 1.00), range: (desLabel as NSString).range(of: self.lifeStyle!))
        attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 0.27, green: 0.51, blue: 0.71, alpha: 1.00), range: (desLabel as NSString).range(of: str))
        self.descriptionLabel.attributedText = attributedStr
    }
    
    func setTotalLabel() {
        let totLabel = "전체 " + supplementList.count.description + "개"
        let fontSize = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let attributedStr = NSMutableAttributedString(string: totLabel)
        attributedStr.addAttribute(.font, value: fontSize, range: (totLabel as NSString).range(of: supplementList.count.description))
        self.totalSuppLabel.attributedText = attributedStr
    }
    
    func getNutrientData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_life_styles/"+lifeStyle!
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? decoder.decode([goodForLifeStyle].self, from: data!) {
                DispatchQueue.main.async {
                    self.nutrients = data
                    var temp = ""
                    for index in 0..<self.nutrients.count {
                        if index == self.nutrients.count-1 {
                            temp += self.nutrients[index].nutrient
                        } else {
                            temp += self.nutrients[index].nutrient + ", "
                        }
                    }
                    self.setDescriptionLabel(str: temp)
                }
            }
        }
    }
    
    func getSupplementData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_life_styles_supplements/"+lifeStyle!
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? decoder.decode([supplement].self, from: data!) {
                DispatchQueue.main.async {
                    self.supplementList = data
                    self.supplementTableView.reloadData()
                    self.setTotalLabel()
                }
            }
        }
    }

}

extension LifeStyleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplementCell", for: indexPath) as! SupplementCell
        
        cell.supplementTitle.text = supplementList[indexPath.row].name
        cell.brand.text = supplementList[indexPath.row].company
        cell.score.text = supplementList[indexPath.row].avg_rating?.description
        
        return cell
    }
    
    
}
