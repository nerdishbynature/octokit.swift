//
//  SigninViewModel.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation
import AuthenticationServices

private struct AuthToken: Codable {
    var accessToken: String
}

private struct OAuthConfig: Codable {
    var clientID: String
    var clientSecret: String
}

@MainActor
final class SinginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    typealias ASPresentationAnchor = UIWindow
    @Published var error: NSError?

    private var callbackURL: String = "octokit-example"
    private var config: OAuthConfig!

    func signin() async -> String? {
        var accessToken: String?
        do {
            try loadConfig()
            let code = try await getCode()
            accessToken = try await getAccessToken(with: code).accessToken
        } catch {
            self.error = error as NSError
        }
        return accessToken
    }

    private func loadConfig() throws {
        guard let configURL = Bundle.main.url(forResource: "OAuthConfig", withExtension: "plist") else { fatalError("No config found") }
        let decoder = PropertyListDecoder()
        let data = try Data(contentsOf: configURL)
        config = try decoder.decode(OAuthConfig.self, from: data)
    }

    private func getCode() async throws -> String {
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(config.clientID)&scope=repo,notifications")!
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURL) { url, error in
                if let error = error {
                    continuation.resume(with: .failure(error))
                }

                if let url = url, let code = url.query?.components(separatedBy: "=").last {
                    continuation.resume(with: .success(code))
                }
            }

            session.presentationContextProvider = self
            session.start()
        }
    }

    private func getAccessToken(with code: String) async throws -> AuthToken {
        let url = URL(string: "https://github.com/login/oauth/access_token?client_id=\(config.clientID)&client_secret=\(config.clientSecret)&code=\(code)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData = try await URLSession.shared.data(for: request, delegate: nil)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let token = try decoder.decode(AuthToken.self, from: jsonData.0)
        return token
    }

    // MARK: - Delegates
    // MARK: ASWebAuthenticationPresentationContextProviding

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
