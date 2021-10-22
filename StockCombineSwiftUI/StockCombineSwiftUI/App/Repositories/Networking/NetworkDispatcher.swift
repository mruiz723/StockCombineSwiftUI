//
//  NetworkDispatcher.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 16/10/21.
//

import Foundation
import Combine

enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest(_ message: String? = nil)
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}

protocol NetworkDispatcherProtocol {
    var urlSession: URLSession { get }
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError>
}

struct NetworkDispatcher: NetworkDispatcherProtocol {

    private(set) var urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// Dispatches an URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided decoded data or an error
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        return urlSession
            .dataTaskPublisher(for: request)
            // Map on Request response
            .tryMap { data, response -> Data in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                     throw httpError(response.statusCode, data: data)
                }

                return data
            }
            // Decode data using our ReturnType
            .decode(type: ReturnType.self, decoder: JSONDecoder())
            // Handle any decoding errors
            .mapError { error in
                if let error = error as? NetworkRequestError {
                    return error
                }
                return handleError(error)
            }
            // Expose our publisher
            .eraseToAnyPublisher()
    }

}

extension NetworkDispatcher {

    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int, data: Data? = nil) -> NetworkRequestError {
        switch statusCode {
        case 400:
            let decoder = JSONDecoder()
            guard let data = data, let errorMsg = try? decoder.decode(ErrorMessage.self, from: data) else {
                return .badRequest()
            }
            return .badRequest(errorMsg.message)
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }

    /// Parses URLSession errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }

}

// For each error type return the appropriate localized description
extension NetworkRequestError {

    var errorDescription: String {
        switch self {
        case .badRequest(let message):
            return NSLocalizedString( message ?? Constants.DefaultErrorMessage.description,
                comment: "Bad Request"
            )
        default:
            return NSLocalizedString( Constants.DefaultErrorMessage.description,
                                      comment: Constants.DefaultErrorMessage.comment
            )
        }
    }

}
