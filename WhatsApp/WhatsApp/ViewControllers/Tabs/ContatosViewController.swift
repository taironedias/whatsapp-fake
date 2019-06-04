//
//  ContatosViewController.swift
//  WhatsApp
//
//  Created by Tairone Dias on 04/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ContatosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewContatos: UITableView!
    
    var userArray: [Usuario] = []
    
    var auth: Auth!
    var storage: Storage!
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.database = Database.database()
        
        // remove a linha entre uma celula e outra
        self.tableViewContatos.separatorStyle = .none
        
        self.getUsuariosDatabase()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula  = tableView.dequeueReusableCell(withIdentifier: "celulaContatos", for: indexPath) as! ContatoTableViewCell
        
        let userR = self.userArray[indexPath.row]
        
        celula.nomeLabel.text = userR.nome
        celula.emailLabel.text = userR.email
        celula.fotoImageView.image = UIImage(named: "padrao")
        
        return celula
    }
    
    
    func getUsuariosDatabase() {
        let usuarios = self.database.reference().child("usuarios")
        let keyUserLogado = FirebaseUtil().getKeyUserLogado()
        
        usuarios.queryOrdered(byChild: "nome").observe(.childAdded) { (snapshot) in
            if let dados = snapshot.value as? NSDictionary {
                if let nome = dados["nome"] as? String {
                    if let email = dados["email"] as? String {
                        
                        let user = Usuario(nome: nome, email: email, foto: "padrao")
                        
                        if snapshot.hasChild("foto") {
                            if let namePhoto = dados["foto"] as? String {
                                user.foto = namePhoto
                            }
                        }
                        
                        
                        if email != self.auth.currentUser?.email {
                            self.userArray.append(user)
                            self.tableViewContatos.reloadData()
                        }
                        
                    }
                }
            }
        }
        
        
    }

}
