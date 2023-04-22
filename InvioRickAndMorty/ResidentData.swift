//
//  ResidentData.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 19.04.2023.
//

import Foundation

struct ResidentData: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Locationn
    let location: Locationn
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Locationn: Decodable {
    let name: String
    let url: String
}
