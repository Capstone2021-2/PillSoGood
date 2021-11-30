//
//  CategoryViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/10.
//

import UIKit

let constitution = ["열태양", "한태양", "열태음", "한태음", "열소양", "한소양", "열소음", "한소음"]

class CategoryItemCell: UITableViewCell {
    
    @IBOutlet weak var itemView: UIView! {
        didSet {
            contentView.layer.shadowColor = UIColor.lightGray.cgColor
            contentView.layer.masksToBounds = false
            contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
            contentView.layer.shadowRadius = 2
            contentView.layer.shadowOpacity = 0.3
            
        }
    }
    @IBOutlet weak var itemLabel: UILabel!
    
}

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemList: [Any]? = nil
    var filteredList: [Any]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        searchBar.delegate = self
    }
    
    func getData() {
        let url: String
        let decoder = JSONDecoder()
        let title = self.title!
        if title.contains("영양소") {
            url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/main_nutrients"
            getCategoryList(url: url) { data in
                if let data = try? decoder.decode([nutrient].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.filteredList = data
                        self.setTotalLabel()
                        self.categoryTableView.reloadData()
                    }
                }
            }
        } else if title.contains("기능") {
            url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/organs"
            getCategoryList(url: url) { data in
                if let data = try? decoder.decode([organ].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.filteredList = data
                        self.setTotalLabel()
                        self.categoryTableView.reloadData()
                    }
                }
            }
        } else if title.contains("브랜드") {
            getCategoryList(url: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/brands") { data in
                if let data = try? decoder.decode([brand].self, from: data!) {
                    DispatchQueue.main.async {
                        self.itemList = data
                        self.filteredList = data
                        self.setTotalLabel()
                        self.categoryTableView.reloadData()
                    }
                }
            }
        } else if title.contains("체질") {
            self.itemList = constitution
            self.filteredList = constitution
            self.setTotalLabel()
            self.categoryTableView.reloadData()
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
    
    func setTotalLabel() {
        let totLabel = "전체 " + (itemList?.count.description ?? "0") + "개"
        let fontSize = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let attributedStr = NSMutableAttributedString(string: totLabel)
        attributedStr.addAttribute(.font, value: fontSize, range: (totLabel as NSString).range(of: itemList?.count.description ?? "0"))
        self.totalLabel.attributedText = attributedStr
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
                categoryVC.categoryType = 2
            } else if itemList?[indexPath.row] is String {
                let name = (itemList?[indexPath.row] as! String)
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
        } else if itemList?[indexPath.row] is String {
            cell.itemLabel.text = (itemList?[indexPath.row] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if title!.contains("영양소") {
            itemList = searchText.isEmpty ? filteredList : (filteredList! as! [nutrient]).filter({ nutrient in
                return nutrient.name.range(of: searchText, options: .caseInsensitive) != nil
            })
        } else if title!.contains("기능") {
            itemList = searchText.isEmpty ? filteredList : (filteredList! as! [organ]).filter({ organ in
                return organ.organ.range(of: searchText, options: .caseInsensitive) != nil
            })
        } else if title!.contains("브랜드") {
            itemList = searchText.isEmpty ? filteredList : (filteredList! as! [brand]).filter({ brand in
                return brand.name.range(of: searchText, options: .caseInsensitive) != nil
            })
        } else {
            
        }
        setTotalLabel()
        categoryTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
