import Foundation

struct LoginResponse: Codable {
    let user: ModelUser
    let nama: String
    let token: String
    let status: Int
}
