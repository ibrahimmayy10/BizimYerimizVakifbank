//
//  ProvincesViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import Foundation

class ProvincesViewModel {
    func getDataProvinces(completion: @escaping ([ProvinceData]?) -> Void) {
        guard let url = URL(string: "https://turkiyeapi.dev/api/v1/provinces") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion([])
            } else if let data = data {
                let response = try? JSONDecoder().decode(ProvincesModel.self, from: data)
                completion(response?.data)
            }
        }.resume()
    }
    
    func getDataDistricts(for province: String, completion: @escaping ([Districts]?) -> Void) {
        guard let url = URL(string: "https://turkiyeapi.dev/api/v1/provinces?name=\(province)") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ProvincesModel.self, from: data)
                if let provinceData = response.data.first(where: { $0.name == province }) {
                    completion(provinceData.districts)
                } else {
                    completion([])
                }
            } catch {
                print("veriler yüklenmedi")
            }
        }.resume()
    }
}
