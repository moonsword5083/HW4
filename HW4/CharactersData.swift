//
//  CharactersData.swift
//  HW4
//
//  Created by User16 on 2020/5/13.
//  Copyright © 2020 00657143. All rights reserved.
//

import Foundation
import Combine

class CharactersData: ObservableObject{
    var cancellable: AnyCancellable?
    @Published var characters = [Character]()
    
    init(){
        if let data = UserDefaults.standard.data(forKey: "characters"){
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([Character].self, from: data){
                characters = decodedData
            }
        }
        cancellable = $characters
            .sink(receiveValue: { (value) in
                let encoder = JSONEncoder()
                do{
                    let data = try? encoder.encode(value)
                    UserDefaults.standard.set(data, forKey: "characters")
                }
                catch{
                    
                }
            })
    }
    
}
