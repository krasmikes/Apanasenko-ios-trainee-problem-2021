//
//  Data.swift
//  Avito-ios-trainee-problem-2021
//
//  Created by Михаил Апанасенко 2 on 09.09.2021.
//

import Foundation

struct AvitoData: Decodable {
    var company: Company
}

struct Company: Decodable {
    let name: String
    var employees: [Employee]
}

struct Employee: Decodable {
    let name: String
    let phone_number: String
    var skills: [String]
}
