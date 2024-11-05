import Foundation
import Combine
import CoreData

class UserViewModel: ObservableObject {
    @Published var user: ModelUser?
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var showError: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let apiService = APIService()
    
    private let context = PersistenceController.shared.container.viewContext

    func login(username: String, password: String) {
        
        if username.isEmpty || password.isEmpty {
            self.isLoggedIn = false
            self.showError = true
            self.errorMessage = "Username and password cannot be empty."
                   
        } else {
            apiService.login(username: username, password: password)
                .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.handleError(error)
                    }
                }, receiveValue: { response in
                    if response.status == 201 {
                        self.user = response.user
                        self.isLoggedIn = true
                        self.errorMessage = ""
                        self.showError = false
                        self.saveUserToCoreData(user: response.user)
                    } else {
                        self.isLoggedIn = false
                        self.showError = true
                        self.errorMessage = "Invalid username or password."
                    }
                })
                .store(in: &cancellables)
            }
        
    }
    
    private func handleError(_ error: URLError) {
        DispatchQueue.main.async {
            switch error.code {
            case .notConnectedToInternet:
                self.errorMessage = "No internet connection."
            case .timedOut:
                self.errorMessage = "Request timed out. Please try again later."
            case .cannotConnectToHost, .networkConnectionLost:
                self.errorMessage = "Cannot connect to server. Please try again later."
            default:
                self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            }
            self.showError = true
        }
    }
    
    private func saveUserToCoreData(user: ModelUser) {
        let userEntity = UserEntity(context: context)
        userEntity.id = Int32(user.id)
        userEntity.employeeId = Int32(user.employeeId)
        userEntity.username = user.username
        userEntity.akses = user.akses
        userEntity.role = user.role
        userEntity.active = Int32(user.active)
        userEntity.createdAt = user.createdAt
        userEntity.updatedAt = user.updatedAt
        
        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
}
