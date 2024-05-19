//
//  Encodable.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation
// This is used to encode a class as a dictionary, it is used to insert records into the database
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
    
}
