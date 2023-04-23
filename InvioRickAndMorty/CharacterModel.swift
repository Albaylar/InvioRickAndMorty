//
//  RickandMortyModel.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import Foundation

struct CharacterResponse : Codable {
    let results : [Character]?
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, image, url, created
    }
}



