//
//  SurveyResultViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/11.
//

import UIKit

class SurveyResultViewController: UIViewController {
    
    @IBOutlet weak var userConstitutionLabel: UILabel!
    var firstConstitution: String?
    var secondConstitution: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        userConstitutionLabel.text = "1순위 : " + firstConstitution! + "\n2순위 : " + secondConstitution!
    }

}
