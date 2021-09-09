//
//  Manager.swift
//  Avito-ios-trainee-problem-2021
//
//  Created by Михаил Апанасенко 2 on 09.09.2021.
//

import Foundation

protocol AvitoManagerDelegate {
    func didUpdateData(manager: AvitoManager, model: AvitoModel)
    func didFailWithError(error: Error)
}

struct AvitoManager {
    private let url = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    var delegate: AvitoManagerDelegate?

    
    func performRequest () {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let model = self.parseJSON(safeData) {
                        delegate?.didUpdateData(manager: self, model: model)
                    }
                }
            }
            task.resume()
        }
    }
    private func parseJSON(_ data: Data) -> AvitoModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(AvitoData.self, from: data)
            let model = AvitoModel(data: decodedData)
            return model
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
