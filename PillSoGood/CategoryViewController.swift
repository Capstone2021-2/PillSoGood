//
//  CategoryViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/10.
//

import UIKit

class CategoryItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
}

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var itemList: [Any]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getData() {
        let url: String
        let decoder = JSONDecoder()
        let title = self.title
        if title == "영양소" {
            url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/main_nutrients"
            getCategoryList(url: url) { data in
                if let data = try? decoder.decode([nutrient].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.categoryTableView.reloadData()
                    }
                }
            }
        } else if title == "기능" {
            url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/organs"
            getCategoryList(url: url) { data in
                if let data = try? decoder.decode([organ].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.categoryTableView.reloadData()
                    }
                }
            }
        } else if title == "브랜드" {
            getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/brands") { data in
                if let data = try? decoder.decode([brand].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.categoryTableView.reloadData()
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
            guard let data = data else {
                return
            }
            completion(data)
        }.resume()
    }

    
    // 뒤로갈 때 네비게이션바 없애기
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let categoryVC = self.storyboard!.instantiateViewController(identifier: "CategoryDetailViewController") as? CategoryDetailViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
            if itemList?[indexPath.row] is nutrient {
                categoryVC.pk = (itemList?[indexPath.row] as! nutrient).nutrient_pk
                let name = (itemList?[indexPath.row] as! nutrient).name
                categoryVC.title = name
                categoryVC.name = name
                categoryVC.categoryType = 0
            } else if itemList?[indexPath.row] is organ {
                let name = (itemList?[indexPath.row] as! organ).organ
                categoryVC.title = name
                categoryVC.name = name
                categoryVC.categoryType = 1
            } else if itemList?[indexPath.row] is brand {
                let name = (itemList?[indexPath.row] as! brand).name
                categoryVC.title = name
                categoryVC.name = name
                categoryVC.categoryType = 3
            }

            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell") as! CategoryItemCell
        
        if itemList?[indexPath.row] is nutrient {
            cell.itemLabel.text = (itemList?[indexPath.row] as! nutrient).name
        } else if itemList?[indexPath.row] is organ {
            cell.itemLabel.text = (itemList?[indexPath.row] as! organ).organ
        } else if itemList?[indexPath.row] is brand {
            cell.itemLabel.text = (itemList?[indexPath.row] as! brand).name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
