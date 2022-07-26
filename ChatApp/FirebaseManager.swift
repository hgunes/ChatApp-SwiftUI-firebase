//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Harun Gunes on 26/07/2022.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        
        super.init()
    }
}
