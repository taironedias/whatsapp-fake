//
//  Usuario.swift
//  WhatsApp
//
//  Created by Tairone Dias on 04/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import Foundation

class Usuario {
    var nome: String
    var email: String
    var foto: String
    
    init(nome: String, email: String, foto: String? = "") {
        self.nome = nome
        self.email = email
        self.foto = foto!
    }
    
}
