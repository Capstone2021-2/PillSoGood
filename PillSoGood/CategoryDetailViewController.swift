//
//  CategoryDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/10.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var supplementTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var totalSupplementLabel: UILabel!
    @IBOutlet weak var sortedButton: UIButton!
    
    var pk: Int? = nil
    var name: String? = nil
    var categoryType: Int? = nil    // 0: 영양소 1: 기능 2: 브랜드 3: 체질
    var supplementList = [supplement]()
    var filteredSupplement = [supplement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        supplementTableView.register(UINib(nibName: "SupplementCell", bundle: nil), forCellReuseIdentifier: "SupplementCell")
        supplementTableView.delegate = self
        supplementTableView.dataSource = self
        
        setSortedButton()
        setSearchBar()
        Task {
            try? await getData()
            self.supplementTableView.reloadData()
            self.totalSupplementLabel.text = self.supplementList.count.description
        }
        setupLabel()
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
    
    func setupLabel() {
        let str: String
        switch categoryType {
        case 0:
            str = name! + " 영양소가 포함된 영양제"
        case 1:
            str = name! + " 건강에 도움이 되는 영양제"
        case 3:
            str = name! + " 체질인 사람에게 도움이 되는 영양제"
        case 2:
            str = name! + "의 영양제 제품"
        default:
            return
        }
        let attributedStr = NSMutableAttributedString(string: str)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (str as NSString).range(of: name!))
        self.descriptionLabel.attributedText = attributedStr
    }
    
    func getData() async throws {
        let decoder = JSONDecoder()
        if categoryType == 0 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/nutrient_to_supplement/"+pk!.description
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!, delegate: .none)
            if let data = try? decoder.decode([nutrientFacts].self, from: data) {
                for supp in data {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/"+supp.supplement.description
                    let (data2, _) = try await URLSession.shared.data(from: URL(string: url2)!, delegate: .none)
                    if let data2 = try? decoder.decode(supplement.self, from: data2) {
                        self.supplementList.append(data2)
                        self.filteredSupplement.append(data2)
                    }
                }
            }
        }
        else if categoryType == 1 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_organs_supplements/"+name!
            let (data, _) = try await URLSession.shared.data(from: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, delegate: .none)
            if let data = try? decoder.decode([supplement].self, from: data) {
                self.supplementList = data
                self.filteredSupplement = data
            }
//            getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
//                if let data = try? decoder.decode([supplement].self, from: data!) {
//                    DispatchQueue.main.async {
//                        self.supplementList = data
//                        self.filteredSupplement = data
//                        self.supplementTableView.reloadData()
//                        self.totalSupplementLabel.text = data.count.description
//                    }
//                }
//            }
            
        }
        else if categoryType == 2 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/brands/name/"+name!
            let (data, _) = try await URLSession.shared.data(from: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, delegate: .none)
            if let data = try? decoder.decode([supplement].self, from: data) {
                self.supplementList = data
                self.filteredSupplement = data
            }
//            getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
//                if let data = try? decoder.decode([supplement].self, from: data!) {
//                    DispatchQueue.main.async {
//                        self.supplementList = data
//                        self.filteredSupplement = data
//                        self.supplementTableView.reloadData()
//                        self.totalSupplementLabel.text = data.count.description
//                    }
//                }
//            }
        }
        else if categoryType == 3 {
            let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_body_types_supplements/" + name!
            let (data, _) = try await URLSession.shared.data(from: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, delegate: .none)
            if let data = try? decoder.decode([supplement].self, from: data) {
                self.supplementList = data
                self.filteredSupplement = data
            }
        }
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplementCell", for: indexPath) as! SupplementCell
        
        let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + supplementList[indexPath.row].tmp_id + ".jpg"
        cell.supplementImageView.image = UIImage(named: "default")
        if let image = Cache.imageCache.object(forKey: url as NSString) {
            cell.supplementImageView.image = image
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: url)!) {
                    if let image = UIImage(data: data) {
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
        cell.score.text = supplementList[indexPath.row].avg_rating.description + " (" + supplementList[indexPath.row].review_num.description + ")"
        cell.theNumOfPeople.text = supplementList[indexPath.row].taking_num.description
        
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
        return 130
    }
    
}

extension CategoryDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        supplementList = searchText.isEmpty ? filteredSupplement : filteredSupplement.filter({ supplement in
            return supplement.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        totalSupplementLabel.text = supplementList.count.description
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
