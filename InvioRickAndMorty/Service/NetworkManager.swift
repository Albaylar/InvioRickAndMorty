//
//  NetworkManager.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import Foundation
import Alamofire

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrl = "https://rickandmortyapi.com/api"
    
    private init() {}
    
    func getLocations(completion: @escaping (Result<[Location], Error>) -> Void) {
        let url = "\(baseUrl)/location"
        AF.request(url)
            .validate()
            .responseDecodable(of: LocationData.self) { response in
                switch response.result {
                case .success(let locationData):
                    completion(.success(locationData.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    func getLocation(id: Int, completion: @escaping (Result<[Location], AFError>) -> Void) {
        let url = "\(baseUrl)/location/\(id)"
        AF.request(url)
            .validate()
            .responseDecodable(of: Location.self) { response in
                switch response.result {
                case .success(let location):
                    completion(.success([location]))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getMultipleCharacters(ids: String, completion: @escaping (Result<CharacterResponse, AFError>) -> Void) {
        let url = "\(baseUrl)/character/\(ids)"
        AF.request(url)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                switch response.result {
                case .success(let characterResponse):
                    completion(.success(characterResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func getSingleCharacters(id: Int, completion: @escaping (Result<CharacterResponse, AFError>) -> Void) {
        let url = "\(baseUrl)/character/\(id)"
        AF.request(url)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                switch response.result {
                case .success(let characterResponse):
                    completion(.success(characterResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

