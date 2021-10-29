//
//  CategoryDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/10.
//

import UIKit

class SupplementCell: UITableViewCell {
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementTitle: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var theNumOfPeople: UILabel!
}

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var supplementTableView: UITableView!
    @IBOutlet weak var descriptionView: UIView!
//    {
//        didSet {
//            descriptionView.layer.cornerRadius = 10
//            descriptionView.layer.borderWidth = 1
//            descriptionView.layer.borderColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1).cgColor
//        }
//    }
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var pk: Int? = nil
    var name: String? = nil
    var categoryType: Int? = nil    // 0: 영양소 1: 기능 2: 체질 3: 브랜드
    var supplementList = [supplement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setupLabel()
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
    }
    
    func setupLabel() {
        let str: String
        switch categoryType {
        case 0:
            str = name! + " 영양소가 포함된 영양제"
        case 1:
            str = name! + " 건강에 도움이 되는 영양제"
        case 2:
            str = name! + " 체질인 사람에게 도움이 되는 영양제"
        case 3:
            str = name! + "의 영양제 제품"
        default:
            return
        }
        let attributedStr = NSMutableAttributedString(string: str)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (str as NSString).range(of: name!))
        self.descriptionLabel.attributedText = attributedStr
    }
    
    func getData() {
        let decoder = JSONDecoder()
        if categoryType == 0 {
            getNutrientSupplement(pk: self.pk!)
        }
        else if categoryType == 1 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_organs/"+name!
            getCategoryList(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
                if let data = try? decoder.decode([goodForOrgan].self, from: data!) {
                    for nut in data {
                        let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrients/name/"+nut.nutrient
                        self.getCategoryList(url: url2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { [self] data2 in
                            if let data2 = try? decoder.decode(nutrient2.self, from: data2!) {
                                getNutrientSupplement(pk: data2.pk)
                            }
                        }
                    }
                }
            }
        }
        else if categoryType == 2 {
            
        }
        else if categoryType == 3 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/brands/name/"+name!
            getCategoryList(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
                if let data = try? decoder.decode([supplement].self, from: data!) {
                    DispatchQueue.main.async {
                        self.supplementList = data
                        self.supplementTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getNutrientSupplement(pk: Int) {
        let decoder = JSONDecoder()
        getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/"+pk.description) { data in
            if let data = try? decoder.decode([nutrientFacts].self, from: data!) {
                for supp in data {
                    self.getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/"+supp.supplement.description) { data2 in
                        DispatchQueue.main.async {
                            if let data2 = try? decoder.decode(supplement.self, from: data2!) {
                                self.supplementList.append(data2)
                                self.supplementTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCategoryList(url: String, completion: @escaping (Data?) -> Void){
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("no data")
                return
            }
            completion(data)
        }.resume()
    }

}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    // tableViewCell 클릭 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let detailVC = self.storyboard!.instantiateViewController(identifier: "SupplementDetailViewController") as? SupplementDetailViewController {
            detailVC.title = "세부정보"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .lightGray
            self.navigationItem.backBarButtonItem = backBarButtonItem

            detailVC.supplementInfo = supplementList[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
