//
//  EndPoint.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import Alamofire
import Foundation

enum EndPoint {
    case getLocations
    case getMultipleCharacters(ids: String)
    case getLocation(id: Int)
}

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }

    func request() -> URLRequest
}

extension EndPoint: EndpointProtocol {
    var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self {
        case .getLocations:
            return "/location"
        case .getMultipleCharacters(let ids):
            return "/character/\("[" + ids + "]")"
        case .getLocation(let id):
            return "/location/\(id)"
            
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            fatalError("Invalid URL")
        }
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
