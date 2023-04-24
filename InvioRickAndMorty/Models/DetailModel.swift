//
//  DetailModel.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 24.04.2023.
//

import Foundation

// MARK: - DetailResponse
struct DetailResponse: Codable {
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    let origin, location: LocationCharacter?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

// MARK: - Location
struct LocationCharacter: Codable {
    let name: String?
    let url: String?
}
