//
//  Model.swift
//  Avito-ios-trainee-problem-2021
//
//  Created by Михаил Апанасенко 2 on 09.09.2021.
//

import Foundation

struct AvitoModel {
    var data: AvitoData
    
    mutating func sortEmployees() {
        data.company.employees.sort { $0.name < $1.name }
    }
}
