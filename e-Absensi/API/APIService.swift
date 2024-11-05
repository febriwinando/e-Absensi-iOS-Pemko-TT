import Foundation
import Combine

class APIService {
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, URLError> {
        let urlString = "https://absensi.tebingtinggikota.go.id/api/ios/login/"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .mapError { $0 as? URLError ?? URLError(.unknown) }
            .eraseToAnyPublisher()
    }
}
