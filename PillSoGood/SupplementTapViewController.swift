//
//  SupplementTapViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/05.
//

import UIKit

class BestSupplementCell: UITableViewCell {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementTitle: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var theNumOfPeople: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankImageView: UIImageView!
    
}


class SupplementTapViewController: UIViewController {
    
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var bestSupplementTableView: UITableView!    // 베스트 영양제 테이블뷰
    var bestSupplementList = [supplement]()
    
    var searchController: UISearchController!
    private var resultsTableController: ResultsTableViewController!
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        getBestSupplement()
        
        bestSupplementTableView.delegate = self
        bestSupplementTableView.dataSource = self
        bestSupplementTableView.backgroundColor = .white
    }
    
    // searchBar custom
    func setSearchBar() {
        resultsTableController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableViewController") as? ResultsTableViewController
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchBar.placeholder = "영양제, 영양소, 브랜드 검색"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
    }
    
    func getBestSupplement() {
        getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/tmp_best_supplements/abc") { data in
            if let data = try? self.decoder.decode([supplement].self, from: data!) {
                DispatchQueue.main.async {
                    self.bestSupplementList = data
                    self.bestSupplementTableView.reloadData()
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
    
    // 카테고리 버튼 클릭 시
    @IBAction func moveToCategory(_ sender: UIButton) {
        if let categoryVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController {
            categoryVC.title = sender.titleLabel?.text ?? ""
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
 
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "영양제"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "pills.fill")
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = nil
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}

extension SupplementTapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchStr = searchBar.text!
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/search/" + searchStr
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? self.decoder.decode([result].self, from: data!) {
                DispatchQueue.main.async {
                    if let resultsController = self.searchController.searchResultsController as? ResultsTableViewController {
                        resultsController.results = data
                        resultsController.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SupplementTapViewController: UISearchControllerDelegate {
    
}

extension SupplementTapViewController: UITableViewDelegate, UITableViewDataSource {
    // tableView의 row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestSupplementList.count
    }
    
    // 어떤 tableViewCell 반환할 지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestSupplementCell", for: indexPath) as! BestSupplementCell
        
        let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + bestSupplementList[indexPath.row].tmp_id + ".jpg"
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
        switch indexPath.row + 1 {
        case 1, 2, 3 :
            cell.rankLabel.text = ""
            cell.rankImageView.image = UIImage(named: "trophy-"+(indexPath.row+1).description)
            break
        default:
            cell.rankLabel.text = (indexPath.row + 1).description
            cell.rankImageView.image = UIImage(named: "badge")
            break
        }
        cell.supplementTitle.text = bestSupplementList[indexPath.row].name
        cell.brand.text = bestSupplementList[indexPath.row].company
        cell.score.text = bestSupplementList[indexPath.row].avg_rating.description + " (" + bestSupplementList[indexPath.row].review_num.description + ")"
        cell.theNumOfPeople.text = bestSupplementList[indexPath.row].taking_num.description
        
        return cell
    }
    
    // tableViewCell 클릭 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView === bestSupplementTableView {
            tableView.deselectRow(at: indexPath, animated: true)
        
            if let detailVC = self.storyboard!.instantiateViewController(identifier: "SupplementDetailViewController") as? SupplementDetailViewController {
                detailVC.title = "세부정보"
                let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                backBarButtonItem.tintColor = .lightGray
                self.navigationItem.backBarButtonItem = backBarButtonItem

                detailVC.supplementInfo = bestSupplementList[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedResult = resultsTableController.results[indexPath.row]
            switch selectedResult.type {
            case 0, 2:
                if let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController") as? CategoryDetailViewController {
                    let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                    backBarButtonItem.tintColor = .gray
                    self.navigationItem.backBarButtonItem = backBarButtonItem
                    
                    categoryVC.pk = selectedResult.pk
                    categoryVC.title = selectedResult.name
                    categoryVC.name = selectedResult.name
                    categoryVC.categoryType = selectedResult.type
                    
                    self.navigationController?.pushViewController(categoryVC, animated: true)
                }
            case 1:
                getSupplementRequest(pk: selectedResult.pk) { supplement in
                    DispatchQueue.main.async {
                        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplementDetailViewController") as? SupplementDetailViewController {
                            detailVC.title = "세부정보"
                            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                            backBarButtonItem.tintColor = .lightGray
                            self.navigationItem.backBarButtonItem = backBarButtonItem
                            detailVC.supplementInfo = supplement!
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                    }
                }
//                let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + selectedResult.pk.description
//                getRequest(url: url) { data in
//                    if let data = try? decoder.decode(supplement.self, from: data!) {
//                        DispatchQueue.main.async {
//                            if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplementDetailViewController") as? SupplementDetailViewController {
//                                let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//                                backBarButtonItem.tintColor = .lightGray
//                                self.navigationItem.backBarButtonItem = backBarButtonItem
//                                detailVC.supplementInfo = data
//                                self.navigationController?.pushViewController(detailVC, animated: true)
//                            }
//                        }
//                    }
//                }
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
