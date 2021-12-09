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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortedButton: UIButton!
    
    var supplementList = [supplement]()
    var filteredSupplement = [supplement]()
    var nutrients = [goodForLifeStyle]()
    var lifeStyle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        supplementTableView.register(UINib(nibName: "SupplementCell", bundle: nil), forCellReuseIdentifier: "SupplementCell")
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        
        setSortedButton()
        setSearchBar()
        getNutrientData()
        getSupplementData()
        
    }
    
    func setSortedButton() {
        let inOrderOfRating = UIAction(title: "별점순", image: nil, state: .on) { _ in
            self.supplementList.sort { return $0.avg_rating > $1.avg_rating }
            self.supplementTableView.reloadData()
        }
        let inOrderOfReview = UIAction(title: "리뷰순", image: nil) { _ in
            self.supplementList.sort { return $0.review_num > $1.review_num }
            self.supplementTableView.reloadData()
        }
        let inOrderOfTakingNum = UIAction(title: "복용순", image: nil) { _ in
            self.supplementList.sort { return $0.taking_num > $1.taking_num }
            self.supplementTableView.reloadData()
        }
        
        sortedButton.menu = UIMenu(title: "정렬", image: nil, identifier: nil, options: .displayInline, children: [inOrderOfRating, inOrderOfReview, inOrderOfTakingNum])
        sortedButton.showsMenuAsPrimaryAction = true
        sortedButton.changesSelectionAsPrimaryAction = true
    }
    
    func setSearchBar() {
        searchBar.placeholder = "영양제 이름을 입력하세요."
        searchBar.delegate = self
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
                    self.filteredSupplement = data
                    self.supplementTableView.reloadData()
                    self.totalSuppLabel.text = self.supplementList.count.description
                }
            }
        }
    }

}

extension LifeStyleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplementList.count
    }
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplementCell", for: indexPath) as! SupplementCell
        
        let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + supplementList[indexPath.row].tmp_id + ".jpg"
        cell.supplementImageView.image = UIImage(named: "default")
        if let image = Cache.imageCache.object(forKey: url as NSString) {
            cell.supplementImageView.image = image
        } else {
            DispatchQueue.global().async {
                if let data2 = try? Data(contentsOf: URL(string: url)!) {
                    if let image = UIImage(data: data2) {
                        DispatchQueue.main.async {
                            cell.supplementImageView.image = image
                            Cache.imageCache.setObject(image, forKey: url as NSString)
                        }
                    }
                }
            }
        }
        cell.supplementTitle.text = supplementList[indexPath.row].name
        cell.brand.text = supplementList[indexPath.row].company
        cell.score.text = supplementList[indexPath.row].avg_rating.description
        
        return cell
    }
    
}

extension LifeStyleDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        supplementList = searchText.isEmpty ? filteredSupplement : filteredSupplement.filter({ supplement in
            return supplement.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        totalSuppLabel.text = supplementList.count.description
        supplementTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
