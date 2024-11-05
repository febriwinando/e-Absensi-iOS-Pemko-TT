//
//  e_AbsensiApp.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 17/09/24.
//

import SwiftUI
import GoogleMaps

@main
struct e_AbsensiApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


// Inisialisasi AppDelegate di dalam file yang sama
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Inisialisasi Google Maps SDK dengan API Key Anda
        GMSServices.provideAPIKey("AIzaSyD94o7gB9VMJUj8zEETXdvJy9CnlkRF1-8")
        return true
    }
}
