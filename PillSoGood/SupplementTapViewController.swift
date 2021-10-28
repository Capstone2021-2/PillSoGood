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
    
}


class SupplementTapViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var categoryButtons: [UIButton]! {
        didSet {
            for button in categoryButtons {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1).cgColor
                button.layer.cornerRadius = 10
            }
        }
    }
    
    @IBOutlet weak var bestSupplementTableView: UITableView!    // 베스트 영양제 테이블뷰
    var bestSupplementList = [supplement]()
    
    
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
        // UIView shadow
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowOpacity = 0.4
        topView.layer.shadowRadius = 1
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.masksToBounds = false
        
        let searchBarImage = UIImage()
        searchBar.backgroundImage = searchBarImage
        
    }
    
    func getBestSupplement() {
        let decoder = JSONDecoder()
        getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/tmp_best_supplements/abc") { data in
            if let data = try? decoder.decode([supplement].self, from: data!) {
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
        self.navigationController?.isNavigationBarHidden = true
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
    
}

extension SupplementTapViewController: UITableViewDelegate, UITableViewDataSource {
    // tableView의 row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestSupplementList.count
    }
    
    // 어떤 tableViewCell 반환할 지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestSupplementCell", for: indexPath) as! BestSupplementCell
        
        cell.rankLabel.text = (indexPath.row + 1).description
        cell.supplementTitle.text = bestSupplementList[indexPath.row].name
        cell.brand.text = bestSupplementList[indexPath.row].company
        cell.score.text = bestSupplementList[indexPath.row].avg_rating?.description
        cell.theNumOfPeople.text = "0"
        
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

            detailVC.supplementInfo = bestSupplementList[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
