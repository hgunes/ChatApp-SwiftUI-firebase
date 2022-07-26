//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Harun Gunes on 26/07/2022.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}
