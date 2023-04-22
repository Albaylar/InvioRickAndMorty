//
//  NetworkManager.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(endPoint.request()).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLocations(completion: @escaping (Result<LocationData, Error>) -> Void) {
        let endPoint = EndPoint.getLocation
        request(endPoint, completion: completion)
    }
    
    func getResidents(locationID: Int, completion: @escaping (Result<LocationData, Error>) -> Void) {
        let endPoint = EndPoint.getResidents(locationID: locationID)
        request(endPoint, completion: completion)
    }
    
    func getCharacters(from url: String,completion:@escaping (Result<CharacterData, Error>) -> Void) {
        let endPoint = EndPoint.getCharacters
        request(endPoint, completion: completion)
    }
    
    

}
