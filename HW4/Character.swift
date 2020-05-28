//
//  Character.swift
//  HW4
//
//  Created by User16 on 2020/5/13.
//  Copyright © 2020 00657143. All rights reserved.
//

import Foundation

struct Character: Identifiable, Codable {
    let id = UUID()
    var name: String
    var useful: Int
    var favourite: Bool
    var job:String
}
