//
//  LocationModel.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 19.04.2023.
//

import Foundation

struct LocationData: Codable {
    let results: [Location]?
}
struct Location: Codable, Equatable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String] 
    let url: String
    let created: String
}

