//
//  Nutrient.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/10.
//

import Foundation

struct Nutrient: Codable, Hashable {
    let name: String
    let upper: Float
    let lower: Float
    let unit: String
}
