import SwiftUI
import GoogleMaps
import CoreLocation

struct AbsenPegawai: View {
    @StateObject private var locationManager = LocationManager() // Menggunakan StateObject untuk locationManager

    var body: some View {
        VStack {
            // Menampilkan Google Maps View
            GoogleMapView(locationManager: locationManager)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
                .clipShape(BottomRoundedCorners(radius: 40))
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                Spacer()
                Text("Jarak ke tujuan: \(locationManager.distanceToDestination, specifier: "%.2f") meter")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding()
            }
        }
        .onAppear {
            locationManager.startUpdatingLocation() // Memulai pembaruan lokasi saat tampilan muncul
        }
        .onDisappear {
            locationManager.stopUpdatingLocation() // Menghentikan pembaruan lokasi saat tampilan menghilang
        }
    }
}


struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.destinationCoordinate.latitude,
                                              longitude: locationManager.destinationCoordinate.longitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Tidak ada marker untuk tujuan
        
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Update posisi pengguna pada peta
        if let userLocation = locationManager.currentLocation {
            // Pindahkan kamera ke lokasi pengguna
            mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude,
                                                      longitude: userLocation.longitude, zoom: 18.0)
            
            // Perbarui atau buat marker untuk lokasi pengguna
            if let userMarker = context.coordinator.userMarker {
                // Jika userMarker sudah ada, cukup perbarui posisinya
                userMarker.position = userLocation
            } else {
                // Jika userMarker belum ada, buat marker baru
                let newMarker = GMSMarker(position: userLocation)
                newMarker.title = "Lokasi Anda"
                
                // Ganti marker dengan gambar PNG kustom
                if let markerImage = UIImage(named: "ic_asnlk") {
                    newMarker.icon = markerImage // Ganti dengan ikon PNG
                }

                newMarker.map = mapView
                context.coordinator.userMarker = newMarker
            }
        }
    }

    // Coordinator untuk menyimpan referensi userMarker
    class Coordinator {
        var userMarker: GMSMarker?
    }
}
