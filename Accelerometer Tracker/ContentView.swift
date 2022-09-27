//
//  ContentView.swift
//  Accelerometer Tracker
//
//  Created by Samson Chan on 2022-09-19.
//

import SwiftUI
import CoreMotion
import SQLite

class SQLite

//class LocalFileManager {
//    static let instance = LocalFileManager()
//
//    func saveData(pitch: String, yaw: String, roll: String) {
//
//        guard
//            let data = pitch else {
//            print("Error getting data")
//            return
//        }
//    guard
//        let path = FileManager
//        .default
//        .urls(for: .cachesDirectory, in: .userDomainMask)
//        .first?
//        .appendingPathComponent("data.csv") else {
//            print("Error getting path")
//            return
//        }
//        do {
//            try data.write(to: path)
//            print("Success saving")
//
//        } catch let error {
//            print("Error saving...\(error)")
//
//        }
//
//}
final class CoreMotionViewModel: ObservableObject {
    
//    let dataManager = LocalFileManager.instance
    
    // -- what we share
    @Published var pitch: Double = 0.0
    @Published var yaw: Double = 0.0
    @Published var roll: Double = 0.0
    
    // -- core motion manager
    private var manager: CMMotionManager

    // -- initialisation
    init() {
        
        // -- create the instance
        self.manager = CMMotionManager()
        
        // -- how often to get the data
        self.manager.deviceMotionUpdateInterval = 1/60
        
        // -- start it on the main thread
        self.manager.startDeviceMotionUpdates(to: .main) { motionData, error in
            
            // -- error lets get out of here
            guard error == nil else {
                print(error!)
                return
            }
            
            
            // -- update the data
            if let motionData = motionData {
                print(motionData.attitude.pitch)
                self.pitch = motionData.attitude.pitch
                self.yaw = motionData.attitude.yaw
                self.roll = motionData.attitude.roll
//                self.dataManager.saveData(pitch: String(self.pitch), yaw: String(self.yaw), roll: String(self.roll))

                }

            }
        }
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

extension FileManager {
    
    static var documentDirectoryURL: URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL
    }
    
}
    
struct ContentView: View {
    
    // -- where the data lives and update
    @ObservedObject var motion = CoreMotionViewModel()
//    @ObservedObject var data = LocalFileManager()
    let filename = FileManager.documentDirectoryURL("data.txt")
//    let filename = FileManager.documentDirectoryURL

    func saveSth() {
        do {
            try String(motion.pitch).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
                print("error")
        }
    }


    var body: some View {
        VStack {
            Text("Data")
            Text("pitch: \(motion.pitch)")
            Text("yaw: \(motion.yaw)")
            Text("roll: \(motion.roll)")

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
