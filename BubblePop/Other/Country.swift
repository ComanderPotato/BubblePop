//
//  CountryHelper.swift
//  BubblePop
//
//  Created by Tom Golding on 7/4/2024.
//

import Foundation

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var string = ""
    for char in country.unicodeScalars {
        string.unicodeScalars.append(UnicodeScalar(base + char.value)!)
    }
    return String(string)
}

