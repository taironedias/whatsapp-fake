//
//  CadastroViewController.swift
//  WhatsApp
//
//  Created by Tairone Dias on 03/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class CadastroViewController: UIViewController {

    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var btnCadastrar: UIButton!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        self.btnCadastrar.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        if let nome = self.campoNome.text {
            if let email = self.campoEmail.text {
                if let senha = self.campoSenha.text {
                    if self.verificaTextFields() {
                        self.auth.createUser(withEmail: email, password: senha) { (usuario, error) in
                            if error != nil {
                                LogCustom.log(mensagem: "Erro ao cadastrar usuário")
                                return
                            }
                            
                            LogCustom.log(mensagem: "Usuário cadastrado com sucesso")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func verificaTextFields() -> Bool {
        if let nome = self.campoNome.text {
            if let email = self.campoEmail.text {
                if let senha = self.campoSenha.text {
                    if nome == "" {
                        LogCustom.log(mensagem: "Campo nome vazio!")
                        return false
                    }
                    if email == "" {
                        LogCustom.log(mensagem: "Campo e-mail vazio!")
                        return false
                    }
                    if senha == "" {
                        LogCustom.log(mensagem: "Campo senha vazio!")
                        return false
                    }
                    
                    return true
                    
                } else {
                    LogCustom.log(mensagem: "Não foi possível recuperar a senha!")
                }
            } else {
                LogCustom.log(mensagem: "Não foi possível recuperar o email")
            }
        } else {
            LogCustom.log(mensagem: "Digite seu nome")
        }
        return false
    }
}
