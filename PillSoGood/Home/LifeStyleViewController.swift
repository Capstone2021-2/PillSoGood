//
//  LifeStyleViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class LifeStyleCell: UICollectionViewCell {
    
    @IBOutlet weak var lifeStyleBackground: UIView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
}

class LifeStyleViewController: UIViewController {
    
    struct kindOfLifeStyle : Codable {
        let life_style: String
    }

    @IBOutlet weak var lifeStyleCollectionView: UICollectionView!
    var lifeStyle = [kindOfLifeStyle]()
    
    let colorList = [UIColor(red: 161/255, green: 209/255, blue: 254/255, alpha: 0.9), UIColor.orange.withAlphaComponent(0.6), UIColor(red: 0.75, green: 0.83, blue: 0.95, alpha: 1.00), UIColor(red: 0.92, green: 0.59, blue: 0.58, alpha: 0.9), UIColor(red: 0.76, green: 0.88, blue: 0.77, alpha: 0.9), UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 1.00),
        UIColor(red: 0.58, green: 0.44, blue: 0.86, alpha: 0.6),
        UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1.00),
        UIColor(red: 0.47, green: 0.53, blue: 0.60, alpha: 0.9),
        UIColor(red: 0.87, green: 0.72, blue: 0.53, alpha: 1.00),
        UIColor(red: 1.00, green: 0.63, blue: 0.48, alpha: 1.00),
        UIColor(red: 0.94, green: 0.90, blue: 0.55, alpha: 1.00)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        lifeStyleCollectionView.delegate = self
        lifeStyleCollectionView.dataSource = self
        
        getData()
    }
    
    func getData() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/life_styles"
        getRequest(url: url) { data in
            if let data = try? decoder.decode([kindOfLifeStyle].self, from: data!) {
                DispatchQueue.main.async {
                    self.lifeStyle = data
                    self.lifeStyleCollectionView.reloadData()
                }
            }
        }
    }
    
}

extension LifeStyleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lifeStyle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeStyleCell", for: indexPath) as! LifeStyleCell
        
        cell.lifeStyleBackground.backgroundColor = colorList.randomElement()
        cell.lifeStyleBackground.cornerRadius = 20
        cell.lifeStyleLabel.text = lifeStyle[indexPath.row].life_style
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let lifeVC = self.storyboard!.instantiateViewController(withIdentifier: "LifeStyleDetailViewController") as? LifeStyleDetailViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
            lifeVC.lifeStyle = lifeStyle[indexPath.row].life_style
            self.navigationController?.pushViewController(lifeVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
