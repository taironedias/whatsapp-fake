//
//  ViewController.swift
//  WhatsApp
//
//  Created by Tairone Dias on 03/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var btnEntrar: UIButton!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.btnEntrar.layer.cornerRadius = 5
        
        // Adicionando ouvinte de usuario autenticado
        self.auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario == nil {
                LogCustom.log(mensagem: "Erro ao autenticar usuario no addStateDidChangeListener")
                return
            }
            
            self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
        }
    }
    
    
    
    @IBAction func entrar(_ sender: Any) {
        if let email = self.campoEmail.text {
            if let senha = self.campoSenha.text {
                if self.verificaTextFields() {
                    self.auth.signIn(withEmail: email, password: senha) { (usuario, error) in
                        if error != nil {
                            LogCustom.log(mensagem: "Erro ao autentificar usuário!")
                            return
                        }
                        
                        if let userLogado = usuario {
                            LogCustom.log(mensagem: "Sucesso ao logar usuário! \(String(describing: userLogado.user.email))")
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func verificaTextFields() -> Bool {
        if let email = self.campoEmail.text {
            if let senha = self.campoSenha.text {
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
        return false
    }
}

