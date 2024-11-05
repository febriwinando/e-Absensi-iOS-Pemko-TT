import Foundation

struct ModelUser: Codable {
    let id: Int
    let employeeId: Int
    let username: String
    let akses: String
    let role: String?
    let active: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeId = "employee_id"
        case username
        case akses
        case role
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
