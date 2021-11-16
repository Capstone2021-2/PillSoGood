//
//  ReviewPageViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class ReviewPageViewController: UIViewController {
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var mySupplement = [[supplement](),[supplement]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.register(UINib(nibName: "ReviewXCell", bundle: nil), forCellReuseIdentifier: "ReviewXCell")
        reviewTableView.register(UINib(nibName: "ReviewOCell", bundle: nil), forCellReuseIdentifier: "ReviewOCell")
        
        getData()
    }
    
    func getData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + UserDefaults.standard.integer(forKey: "pk").description
        getRequest(url: url) { data in
            if let data = try? decoder.decode([takingSupp].self, from: data!) {
                for item in data {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + item.supplement_pk.description
                    getRequest(url: url2) { data2 in
                        DispatchQueue.main.async {
                            if let data2 = try? decoder.decode(supplement.self, from: data2!) {
                                self.mySupplement[0].append(data2)
                                self.reviewTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ReviewPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySupplement[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewXCell", for: indexPath) as! ReviewXCell
            cell.selectionStyle = .none
            cell.supplementName.text = mySupplement[indexPath.section][indexPath.row].name
            cell.brand.text = mySupplement[indexPath.section][indexPath.row].company
            
            cell.actionBlock = {
                if indexPath.section == 0 {
                    tableView.deselectRow(at: indexPath, animated: true)
                    if let detailVC = self.storyboard!.instantiateViewController(identifier: "WriteReviewViewController") as? WriteReviewViewController {
                        detailVC.title = "리뷰 작성"
                        detailVC.supplementInfo = self.mySupplement[0][indexPath.row]
                        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                        backBarButtonItem.tintColor = .lightGray
                        self.navigationItem.backBarButtonItem = backBarButtonItem

                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewOCell", for: indexPath) as! ReviewOCell
        cell.selectionStyle = .none
        
        cell.supplementName.text = mySupplement[indexPath.section][indexPath.row].name
        cell.brand.text = mySupplement[indexPath.section][indexPath.row].company
        
        return cell
    }
    
    
}
