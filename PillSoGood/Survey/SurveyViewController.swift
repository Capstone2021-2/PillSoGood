//
//  SurveyViewController.swift
//  PillSoGood
//
//  Created by haesung on 2021/10/26.
//

import UIKit

class SurveyViewController: UIViewController{
    @IBOutlet weak var surveyTableView: UITableView!
    
    var count = 0
    let questions = ["화가 나면 참을 수가 없고 문제가 해결될 때까지 화를 풀지 못한다.","화가 나면 참지 못하고 화를 내지만，금세 풀리는 편이다.","화를 참고 있으면 가슴이 답답해서 견딜 수 없다.","여간해서는 화를 내지 않으며 남에게 싫은 소리를 잘 안 하거나 못한다.","화가 나면 토라지고 말을 하지 않으며，오랫동안 혼자서 곱씹는다.","다른 사람과 싸워도 뒤끝이 없다.","아집이 세고 독선적이라는 이야기를 들을 때가 있다.","의지가 강하고 고집이 세며，한번 결정한 것은 끝까지 성사시키려고 한다.","자존심이 강해 충고를 받는 것을 매우 싫어한다.","보수적이고 움직임이 적으며，게으른 편이다.","성격이 급하다.","원칙을 어기는 것을 보면 반드시 따진다.","불합리한 조처나 대우를 받으면 반드시 따지고 든다.","생각과 사고가 독특하거나 괴팍한 성격으로 남과 자주 충돌한다.","책임을 맡는 것을 좋아하고 관심 있는 일은 꼼꼼하게 빈틈없이 처리하고자 한다. 하지만 그렇지 않은 일은 깜박깜빡하거나 덜렁거릴 때가 많다.","한 가지 일에는 치밀하지만，두 가지 일을 한꺼번에 할 때는 덤벙댄다.","꼼꼼하거나 치밀함과는 다소 거리가 있다.","한 가지 일을 오래하지 못하고，쉽게 일을 벌이지만 마무리가 잘 안 된다.","동시에 여러 가지 일에 관심을 갖는다.","조용하고 내성적이고 소심하며 소극적이다.","감정을 잘 안 드러내고 신경질이나 화도 거의 내지 않는다.","인정이 많고 눈물이 많다.","예민하고 쉽게 우울해지며，섭섭한 말에 쉽게 상처를 받는다.","형식과 격식을 중시하고 마음이 불안정해지기 쉬우며，우울증에 잘 빠진다.","기분이 좋으면 계산하지 않고 베풀기를 잘한다.","귀가 얇아서 남의 말을 쉽게 잘 믿는다.","의심이 많고 신중해 남의 말을 잘 믿지 않는다.","실수가 잦고 경솔하며 감정 기복이 심하다.","생각과 행동이 늘 바쁘고 사교성이 좋으며，유머 감각이 뛰어나다.","남의 이야기를 잘 들어주며，한자리에 아주 오래 앉아 있는 편이다.","사람들과 어울려 다니기를 좋아한다.","일찍 자고 일찍 일어나며 한자리에 오래 있지 못한다."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension SurveyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
        cell.questionLabel.text = (indexPath.row+1).description + ". " + questions[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
