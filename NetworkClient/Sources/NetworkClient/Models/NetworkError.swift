//
//  NetworkError.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case decodingError(Error)
    case encodingError(Error)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case unexpectedStatusCode(Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "La réponse du serveur est invalide"
        case .decodingError(let error):
            return "Erreur de décodage: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Erreur d'encodage: \(error.localizedDescription)"
        case .badRequest:
            return "Requête invalide"
        case .unauthorized:
            return "Non autorisé"
        case .forbidden:
            return "Accès interdit"
        case .notFound:
            return "Ressource non trouvée"
        case .serverError(let code):
            return "Erreur serveur (\(code))"
        case .unexpectedStatusCode(let code):
            return "Code de statut inattendu (\(code))"
        }
    }
}
