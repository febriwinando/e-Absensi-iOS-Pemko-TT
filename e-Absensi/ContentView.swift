//
//  ContentView.swift
//  Absensi_iOS
//
//  Created by Diskominfo Tebing Tinggi on 14/09/24.
//


import CoreData
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: UserEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.username, ascending: true)]
        ) var users: FetchedResults<UserEntity>
    
    var body: some View {
        NavigationView {
            VStack {
                if users.count == 1 {
                    // Menavigasi ke Dashboard ketika sudah login
                    Dashboard()
                    
                } else {
                    // Form login
                    VStack(spacing: 10) {
                        
                        Image("logoabsensilogin") // Pastikan nama gambar sesuai dengan nama file di Assets
                            .resizable() // Memungkinkan gambar untuk diubah ukurannya
                            .aspectRatio(contentMode: .fit) // Mempertahankan rasio aspek gambar
                            .frame(width: 80, height: 80)
                        
                        Text("e-Absensi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#006da4"))

                        
                        if viewModel.showError {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                        }
                        
                        GeometryReader { geometry in
                            TextField("NIP / NIK", text: $username)
                                    .padding(.horizontal, 20)
                                    .frame(width: geometry.size.width * 1, height: 50) // Lebar 90%
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                            }.frame(height: 50)
                        
                        GeometryReader { geometry in
                            SecureField("Kata Sandi", text: $password)
                                .padding(.horizontal, 20)
                                .frame(width: geometry.size.width * 1, height: 50) // Lebar 90%
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                        }.frame(height: 50)
                        
                        Button(action: {
                            viewModel.login(username: username, password: password)
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.headline)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 0)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
