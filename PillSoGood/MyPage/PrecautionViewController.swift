//
//  PrecautionViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/12/02.
//

import UIKit

class PrecautionViewController: UIViewController {
    
    @IBOutlet weak var nutrientName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var Nutname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nutrientName.text = Nutname ?? "error"
        
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/cautions/search/" + Nutname!
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? decoder.decode(caution.self, from: data!) {
                DispatchQueue.main.async {
                    self.descriptionLabel.text = data.caution
                }
            }
        }
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
