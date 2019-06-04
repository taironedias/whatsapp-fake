//
//  AjustesViewController.swift
//  WhatsApp
//
//  Created by Tairone Dias on 03/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class AjustesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    var auth: Auth!
    var storage: Storage!
    var database: Database!
    
    var imagePicker = UIImagePickerController()
    var usuario: Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.database = Database.database()
        
        self.imagePicker.delegate = self
        self.arredondarImagem()
        
        self.getDadosUser()
    }
    
    
    
    @IBAction func alterarImagem(_ sender: Any) {
        self.imagePicker.sourceType = .savedPhotosAlbum
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Recuperando a chave em base 64  do usuario
        let idImagem = FirebaseUtil().getKeyUserLogado()
        
        // Configurando o Firebase Storage
        let imgRef = self.storage.reference()
        let imgFolder = imgRef.child("imagens").child("perfil")
        let nameImg = "\(idImagem).jpg"
        let imgFile = imgFolder.child(nameImg)
        
        if let imagemR = info[.originalImage] as? UIImage {
            self.imagem.image = imagemR
            
            if let imgData = imagemR.jpegData(compressionQuality: 0.1) {
                imgFile.putData(imgData, metadata: nil) { (metaData, error) in
                    if error != nil {
                        LogCustom.log(mensagem: "Erro no putData didFinishPickingMediaWithInfo")
                        return
                    }
                    
                    LogCustom.log(mensagem: "Sucesso ao fazer upload da imagem!")
                    
                    
                    
                }
            }
            
            // salvando nome da imagem no Firebasse Database
            self.updateDadosUser(namePhoto: nameImg)
            
            
        } else {
            LogCustom.log(mensagem: "Não foi possível recuperar imagem do didFinishPickingMediaWithInfo")
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func updateDadosUser(namePhoto: String) {
        
        // recupera no Firebase a referencia de usuario
        let usuarios = self.database.reference().child("usuarios")
        // recupera a chave em base64 do usuario
        let keyUserLogado = FirebaseUtil().getKeyUserLogado()
        // recupera no Firebase a referencia do usuario logado
        let userRef = usuarios.child(keyUserLogado)
        
        // verificacao simples se o objeto global está setado
        if self.usuario.email != "" {
            self.usuario.foto = namePhoto
            
            let newDados = [
                "nome": self.usuario.nome,
                "email": self.usuario.email,
                "foto": self.usuario.foto
            ]
            
            userRef.setValue(newDados)
        }
        
    }
    
    
    func getDadosUser() {
        // recupera no Firebase a referencia de usuario
        let usuarios = self.database.reference().child("usuarios")
        // recupera a chave em base64 do usuario
        let keyUserLogado = FirebaseUtil().getKeyUserLogado()
        // recupera no Firebase a referencia do usuario logado
        let userRef = usuarios.child(keyUserLogado)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dados = snapshot.value as? NSDictionary {
                if let nome = dados["nome"] as? String {
                    if let email = dados["email"] as? String {
                        self.usuario = Usuario(nome: nome, email: email)
                        self.labelNome.text = self.usuario.nome
                        self.labelEmail.text = "Email: "+self.usuario.email
                        
                        if snapshot.hasChild("foto") {
                            if let namePhoto = dados["foto"] as? String {
                                self.usuario.foto = namePhoto
                                
                                let imgRef = self.storage.reference().child("imagens")
                                let imgFolder = imgRef.child("perfil")
                                let imgFile = imgFolder.child(self.usuario.foto)
                                
                                imgFile.getMetadata(completion: { (metaData, error) in
                                    if error != nil {
                                        LogCustom.log(mensagem: "Erro ao carregar a imagem!")
                                        return
                                    }
                                    
                                    // START Download URL
                                    imgFile.downloadURL(completion: { (url, error) in
                                        if let urlResult = url?.absoluteString {
                                            let url = String(describing: urlResult)
                                            //LogCustom.log(mensagem: "Url: \(url)")
                                            
                                            self.imagem.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "padrao"))
                                            
                                        }
                                    })
                                    // END Download URL
                                    
                                })
                                
                            }
                        }
                        
                        
                    } else {
                        LogCustom.log(mensagem: "Erro ao recuperar dados[email]")
                    }
                } else {
                    LogCustom.log(mensagem: "Erro ao recuperar dados[nome]")
                }
            } else {
                LogCustom.log(mensagem: "Erro ao recuperar snapshot.value")
            }
        }
        
    }
    
    
    
    @IBAction func deslogar(_ sender: Any) {
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            LogCustom.log(mensagem: "Erro ao deslogar usuário!")
        }
    }
    
    func arredondarImagem() {
        //self.imagem.layer.borderWidth = 1
        self.imagem.layer.masksToBounds = false
        //self.imagem.layer.borderColor = UIColor.black.cgColor
        self.imagem.layer.cornerRadius = self.imagem.frame.height/2
        self.imagem.clipsToBounds = true
    }
    
}
