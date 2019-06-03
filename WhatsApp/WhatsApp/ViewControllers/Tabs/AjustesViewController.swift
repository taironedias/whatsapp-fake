//
//  AjustesViewController.swift
//  WhatsApp
//
//  Created by Tairone Dias on 03/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class AjustesViewController: UIViewController {
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
    }
    
    @IBAction func deslogar(_ sender: Any) {
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            LogCustom.log(mensagem: "Erro ao deslogar usuário!")
        }
    }

}
