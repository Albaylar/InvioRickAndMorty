//
//  EndPoint.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum EndPoint {
    case getLocation
    case getResidents(locationID: Int)
    case getCharacters
    
}

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    
    func request() -> URLRequest
}

extension EndPoint: EndpointProtocol {
    var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self {
        case .getLocation:
            return "/location"
        case .getResidents(let locationID):
            return "/location/\(locationID)"
        case .getCharacters:
            return "/character"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getLocation:
            return nil
        case .getResidents(let locationID):
            return ["location": locationID]
        case .getCharacters:
            return nil
        }
    }
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            fatalError("Invalid URL")
        }
        
        if let parameters = parameters {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
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
