//
//  SurveyViewController.swift
//  PillSoGood
//
//  Created by haesung on 2021/10/26.
//

import UIKit
import CryptoKit

class SurveyViewController: UIViewController{
    @IBOutlet weak var surveyTableView: UITableView!
    
    var count = 0
    let questions = ["화가 나면 참을 수가 없고 문제가 해결될 때까지 화를 풀지 못한다.","화가 나면 참지 못하고 화를 내지만，금세 풀리는 편이다.","화를 참고 있으면 가슴이 답답해서 견딜 수 없다.","여간해서는 화를 내지 않으며 남에게 싫은 소리를 잘 안 하거나 못한다.","화가 나면 토라지고 말을 하지 않으며，오랫동안 혼자서 곱씹는다.","다른 사람과 싸워도 뒤끝이 없다.","아집이 세고 독선적이라는 이야기를 들을 때가 있다.","의지가 강하고 고집이 세며，한번 결정한 것은 끝까지 성사시키려고 한다.","자존심이 강해 충고를 받는 것을 매우 싫어한다.","보수적이고 움직임이 적으며，게으른 편이다.","성격이 급하다.","원칙을 어기는 것을 보면 반드시 따진다.","불합리한 조처나 대우를 받으면 반드시 따지고 든다.","생각과 사고가 독특하거나 괴팍한 성격으로 남과 자주 충돌한다.","책임을 맡는 것을 좋아하고 관심 있는 일은 꼼꼼하게 빈틈없이 처리하고자 한다. 하지만 그렇지 않은 일은 깜박깜빡하거나 덜렁거릴 때가 많다.","한 가지 일에는 치밀하지만，두 가지 일을 한꺼번에 할 때는 덤벙댄다.","꼼꼼하거나 치밀함과는 다소 거리가 있다.","한 가지 일을 오래하지 못하고，쉽게 일을 벌이지만 마무리가 잘 안 된다.","동시에 여러 가지 일에 관심을 갖는다.","조용하고 내성적이고 소심하며 소극적이다.","감정을 잘 안 드러내고 신경질이나 화도 거의 내지 않는다.","인정이 많고 눈물이 많다.","예민하고 쉽게 우울해지며，섭섭한 말에 쉽게 상처를 받는다.","형식과 격식을 중시하고 마음이 불안정해지기 쉬우며，우울증에 잘 빠진다.","기분이 좋으면 계산하지 않고 베풀기를 잘한다.","귀가 얇아서 남의 말을 쉽게 잘 믿는다.","의심이 많고 신중해 남의 말을 잘 믿지 않는다.","실수가 잦고 경솔하며 감정 기복이 심하다.","생각과 행동이 늘 바쁘고 사교성이 좋으며，유머 감각이 뛰어나다.","남의 이야기를 잘 들어주며，한자리에 아주 오래 앉아 있는 편이다.","사람들과 어울려 다니기를 좋아한다.","일찍 자고 일찍 일어나며 한자리에 오래 있지 못한다."]
    var answer = [Int : Int]()
    
    var constitution = ["열태양", "한태양", "열태음", "한태음", "열소양", "한소양", "열소음", "한소음"]
    var score = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var first: String?
    var second: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButtonItem = UIBarButtonItem(title: "제출", style: .done, target: self, action: #selector(submitSurvey))
        rightBarButtonItem.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.isNavigationBarHidden = false
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
    }
    
    @objc func submitSurvey() {
        if answer.count == questions.count {
            for item in answer {
                if item.value == -1 {
                    didNotFinishAlert()
                    return
                }
            }
            constitutionDiagnosis()
            if let resultVC = self.storyboard!.instantiateViewController(identifier: "SurveyResultViewController") as? SurveyResultViewController {
                resultVC.title = "결과 확인"
                resultVC.firstConstitution = first
                resultVC.secondConstitution = second
                let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                backBarButtonItem.tintColor = .lightGray
                self.navigationItem.backBarButtonItem = backBarButtonItem
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        } else {
            didNotFinishAlert()
        }
    }
    
    func didNotFinishAlert() {
        let alert = UIAlertController(title: nil, message: "선택을 안한 질문이 있습니다!\n다시 한번 확인해 주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func constitutionDiagnosis() {
        for item in answer {
            if item.key == 0 {
                if item.value == 0 || item.value == 7{
                    score[1] += 3
                } else if item.value == 1 {
                    score[1] += 2
                } else if item.value == 2 {
                    score[1] += 1
                    score[0] += 1
                } else if item.value == 3 {
                    score[0] += 2
                } else if item.value == 4 {
                    score[0] += 3
                }
            } else if item.key == 1 {
                if item.value == 0 {
                    score[4] += 3
                } else if item.value == 1 {
                    score[4] += 2
                } else if item.value == 2 {
                    score[4] += 1
                    score[0] += 1
                } else if item.value == 3 {
                    score[0] += 2
                } else if item.value == 4 {
                    score[0] += 3
                }
            } else if item.key == 2 {
                if item.value == 0 {
                    score[0] += 2.5
                    score[1] += 2.5
                } else if item.value == 1 {
                    score[0] += 2
                    score[1] += 2
                } else if item.value == 2 {
                    score[0] += 1.5
                    score[1] += 1.5
                } else if item.value == 3 {
                    score[0] += 1
                    score[1] += 1
                } else if item.value == 4 {
                    score[0] += 0.5
                    score[1] += 0.5
                }
            } else if item.key == 3 || item.key == 29{
                if item.value == 0 {
                    score[2] += 3
                    score[3] += 3
                } else if item.value == 1 {
                    score[2] += 2
                    score[3] += 2
                } else if item.value == 2 {
                    score[2] += 1
                    score[3] += 1
                    score[6] += 1
                    score[7] += 1
                } else if item.value == 3 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 4 {
                    score[6] += 3
                    score[7] += 3
                }
            } else if item.key == 4 {
                if item.value == 0 {
                    score[6] += 3
                    score[7] += 3
                } else if item.value == 1 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 2 {
                    score[6] += 1
                    score[7] += 1
                    score[1] += 1
                } else if item.value == 3 {
                    score[1] += 2
                } else if item.value == 4 {
                    score[1] += 3
                }
            } else if item.key == 5 {
                if item.value == 0 {
                    score[4] += 2
                } else if item.value == 1 {
                    score[4] += 1
                    score[2] += 1.5
                } else if item.value == 2 {
                    score[2] += 1.5
                } else if item.value == 3 {
                    score[2] += 1.5
                    score[5] += 1
                } else if item.value == 4 {
                    score[5] += 2
                }
            } else if item.key == 6 || item.key == 8 || item.key == 11 || item.key == 12 || item.key == 13 {
                if item.value == 0 {
                    score[0] += 3
                } else if item.value == 1 {
                    score[0] += 2
                } else if item.value == 2 {
                    score[0] += 1
                    score[1] += 1
                } else if item.value == 3 {
                    score[1] += 2
                } else if item.value == 4 {
                    score[1] += 3
                }
            } else if item.key == 9 {
                if item.value == 0 {
                    score[2] += 3
                } else if item.value == 1 {
                    score[2] += 2
                } else if item.value == 2 {
                    score[2] += 1
                    score[3] += 1
                } else if item.value == 3 {
                    score[3] += 2
                } else if item.value == 4 {
                    score[3] += 3
                }
            } else if item.key == 10 {
                if item.value == 0 {
                    score[0] += 3
                    score[1] += 3
                } else if item.value == 1 {
                    score[0] += 2
                    score[1] += 2
                } else if item.value == 2 {
                    score[0] += 1
                    score[1] += 1
                    score[4] += 1
                } else if item.value == 3 {
                    score[4] += 2
                } else if item.value == 4 {
                    score[4] += 3
                }
            } else if item.key == 14 {
                if item.value == 0 {
                    score[1] += 2.5
                } else if item.value == 1 {
                    score[1] += 2
                } else if item.value == 2 {
                    score[1] += 1.5
                } else if item.value == 3 {
                    score[1] += 1
                } else if item.value == 4 {
                    score[1] += 0.5
                }
            } else if item.key == 15 {
                if item.value == 0 {
                    score[0] += 3
                    score[1] += 3
                } else if item.value == 1 {
                    score[0] += 2
                    score[1] += 2
                } else if item.value == 2 {
                    score[0] += 1
                    score[1] += 1
                    score[4] += 1
                    score[5] += 1
                } else if item.value == 3 {
                    score[4] += 2
                    score[5] += 2
                } else if item.value == 4 {
                    score[4] += 3
                    score[5] += 3
                }
            } else if item.key == 16 {
                if item.value == 0 {
                    score[4] += 3
                } else if item.value == 1 {
                    score[4] += 2
                } else if item.value == 2 {
                    score[4] += 1
                    score[2] += 1
                } else if item.value == 3 {
                    score[2] += 2
                } else if item.value == 4 {
                    score[2] += 3
                }
            } else if item.key == 17 || item.key == 18 || item.key == 27 || item.key == 30 {
                if item.value == 0 {
                    score[4] += 2
                } else if item.value == 1 {
                    score[4] += 1
                    score[0] += 1.5
                    score[1] += 1.5
                } else if item.value == 2 {
                    score[0] += 1.5
                    score[1] += 1.5
                } else if item.value == 3 {
                    score[0] += 1.5
                    score[1] += 1.5
                    score[5] += 1
                } else if item.value == 4 {
                    score[5] += 2
                }
            } else if item.key == 19 {
                if item.value == 0 {
                    score[6] += 3
                    score[7] += 3
                } else if item.value == 1 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 2 {
                    score[6] += 1
                    score[7] += 1
                    score[1] += 1
                    score[3] += 1
                    score[5] += 1
                } else if item.value == 3 {
                    score[1] += 2
                    score[3] += 2
                    score[5] += 2
                } else if item.value == 4 {
                    score[1] += 3
                    score[3] += 3
                    score[5] += 3
                }
            } else if item.key == 20 {
                if item.value == 0 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 1 {
                    score[6] += 1
                    score[7] += 1
                    score[2] += 1.5
                    score[3] += 1.5
                } else if item.value == 2 {
                    score[2] += 1.5
                    score[3] += 1.5
                } else if item.value == 3 {
                    score[2] += 1.5
                    score[3] += 1.5
                    score[5] += 1
                } else if item.value == 4 {
                    score[5] += 2
                }
            } else if item.key == 21 {
                if item.value == 0 {
                    score[4] += 3
                    score[5] += 3
                } else if item.value == 1 {
                    score[4] += 2
                    score[5] += 2
                } else if item.value == 2 {
                    score[4] += 1
                    score[5] += 1
                    score[2] += 1
                    score[3] += 1
                    score[1] += 1
                } else if item.value == 3 {
                    score[2] += 2
                    score[3] += 2
                    score[1] += 2
                } else if item.value == 4 {
                    score[2] += 3
                    score[3] += 3
                    score[1] += 3
                }
            } else if item.key == 22 {
                if item.value == 0 {
                    score[3] += 2
                } else if item.value == 1 {
                    score[3] += 1
                    score[6] += 1.5
                    score[7] += 1.5
                } else if item.value == 2 {
                    score[6] += 1.5
                    score[7] += 1.5
                } else if item.value == 3 {
                    score[6] += 1.5
                    score[7] += 1.5
                    score[1] += 1
                } else if item.value == 4 {
                    score[1] += 2
                }
            } else if item.key == 23 {
                if item.value == 0 {
                    score[6] += 3
                    score[7] += 3
                } else if item.value == 1 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 2 {
                    score[6] += 1
                    score[7] += 1
                    score[3] += 1
                } else if item.value == 3 {
                    score[3] += 2
                } else if item.value == 4 {
                    score[3] += 3
                }
            } else if item.key == 24 {
                if item.value == 0 {
                    score[4] += 3
                    score[5] += 3
                } else if item.value == 1 {
                    score[4] += 2
                    score[5] += 2
                } else if item.value == 2 {
                    score[0] += 1
                    score[1] += 1
                    score[4] += 1
                    score[5] += 1
                } else if item.value == 3 {
                    score[0] += 2
                    score[1] += 2
                } else if item.value == 4 {
                    score[0] += 3
                    score[1] += 3
                }
            } else if item.key == 25 {
                if item.value == 0 {
                    score[4] += 2.5
                    score[5] += 2.5
                } else if item.value == 1 {
                    score[4] += 2
                    score[5] += 2
                } else if item.value == 2 {
                    score[4] += 1.5
                    score[5] += 1.5
                } else if item.value == 3 {
                    score[4] += 1
                    score[5] += 1
                } else if item.value == 4 {
                    score[4] += 0.5
                    score[5] += 0.5
                }
            } else if item.key == 26 {
                if item.value == 0 {
                    score[6] += 3
                    score[7] += 3
                } else if item.value == 1 {
                    score[6] += 2
                    score[7] += 2
                } else if item.value == 2 {
                    score[6] += 1
                    score[7] += 1
                    score[1] += 1
                    score[3] += 1
                } else if item.value == 3 {
                    score[1] += 2
                    score[3] += 2
                } else if item.value == 4 {
                    score[1] += 3
                    score[3] += 3
                }
            } else if item.key == 28 {
                if item.value == 0 {
                    score[4] += 3
                } else if item.value == 1 {
                    score[4] += 2
                    score[0] += 2
                } else if item.value == 2 {
                    score[0] += 1
                    score[1] += 1
                } else if item.value == 3 {
                    score[1] += 2
                    score[5] += 2
                } else if item.value == 4 {
                    score[1] += 3
                    score[5] += 3
                }
            }  else if item.key == 31 {
                if item.value == 0 {
                    score[4] += 3
                } else if item.value == 1 {
                    score[4] += 2
                    score[0] += 2
                } else if item.value == 2 {
                    score[0] += 1
                } else if item.value == 3 {
                    score[0] += 0.5
                    score[1] += 2
                } else if item.value == 4 {
                    score[1] += 3
                }
            }
        }
        
        var index = score.firstIndex(of: score.max()!)!
        first = constitution[index]
        score.remove(at: index)
        constitution.remove(at: index)
        
        index = score.firstIndex(of: score.max()!)!
        second = constitution[index]
        score.remove(at: index)
        constitution.remove(at: index)
        
    }
}

extension SurveyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
        cell.indexPathRow = indexPath.row
        cell.delegate = self
        cell.questionLabel.text = (indexPath.row+1).description + ". " + questions[indexPath.row]
        
        if let index = answer[indexPath.row] {
            cell.resetButton()
            if index != -1 {
                cell.radioButtons[index].isSelected = true
            }
        } else {
            cell.resetButton()
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension SurveyViewController: CellDelegate {
    func CellButtonTapped(key: Int, value: Int) {
        if key != -1 {
            self.answer[key] = value
        }
    }

}
