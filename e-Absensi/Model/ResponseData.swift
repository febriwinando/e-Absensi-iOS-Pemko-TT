//
//  ResponseData.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 01/10/24.
//

import Foundation

// Model untuk data yang diterima dari API
struct ResponseData: Codable {
    let success: Bool
    let message: String
    // Tambahkan properti lain sesuai dengan respons yang diterima
}
