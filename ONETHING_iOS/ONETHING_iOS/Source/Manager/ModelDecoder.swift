//
//  ModelDecoder.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import Foundation

struct ModelDecoder {
    
    static func decodeData<D: Decodable>(fromData data: Data, toType type: D.Type) -> D? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(D.self, from: data) {
            return decodedData
        } else {
            return nil
        }
    }
    
}
