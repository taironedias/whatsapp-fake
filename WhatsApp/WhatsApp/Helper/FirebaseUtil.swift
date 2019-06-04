//
//  FirebaseUtil.swift
//  WhatsApp
//
//  Created by Tairone Dias on 04/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseUtil {
    
    var auth: Auth!
    
    init() {
        self.auth = Auth.auth()
    }
    
    func getKeyUserLogado() -> String {
        
        if self.verificaUserLogado() {
            if let email = self.auth.currentUser?.email {
                let key = Base64.encodingStringToBase64(texto: email)
                return key
            }
        }
        
        return ""
    }
    
    func verificaUserLogado() -> Bool {
        return self.auth.currentUser != nil ? true : false
    }
    
}
