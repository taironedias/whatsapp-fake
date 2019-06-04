//
//  Base64.swift
//  WhatsApp
//
//  Created by Tairone Dias on 03/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import Foundation

class Base64 {
    
    static func encodingStringToBase64(texto: String) -> String {
        let dados = texto.data(using: String.Encoding.utf8)
        let base64 = dados!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64
    }
    
}
