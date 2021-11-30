//
//  MySupplement.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/19.
//

import Foundation

struct MySupplement: Codable {
    let pk: Int
    let name: String
    let brand: String
    let imageUrl: String
    let tmp_id: String
    var useAlarm: Int
    var alarms: [String]?
    var uuid: [String]?
}
