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

class AjustesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    var auth: Auth!
    var storage: Storage!
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString      // Gera um id randomico toda vez que eh utilizado
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        self.imagePicker.delegate = self
        self.arredondarImagem()
    }
    
    
    
    @IBAction func alterarImagem(_ sender: Any) {
        self.imagePicker.sourceType = .savedPhotosAlbum
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Configurando o Firebase Storage
        let imgRef = self.storage.reference()
        let imgFolder = imgRef.child("imagens").child("perfil")
        //let imgFile = imgFolder.child("\(self.idImagem).jpg")
        let imgFile = imgFolder.child("my-image.jpg")
        
        if let imagemR = info[.originalImage] as? UIImage {
            self.imagem.image = imagemR
            
            if let imgData = imagemR.jpegData(compressionQuality: 0.1) {
                imgFile.putData(imgData, metadata: nil) { (metaData, error) in
                    if error != nil {
                        LogCustom.log(mensagem: "Erro no putData didFinishPickingMediaWithInfo")
                        return
                    }
                    
                    LogCustom.log(mensagem: "Sucesso ao fazer upload da imagem!")
                    
                    // START Download URL
//                    imgFile.downloadURL(completion: { (url, error) in
//                        if let urlResult = url?.absoluteString {
//                            let url = String(describing: urlResult)
//                            LogCustom.log(mensagem: "Url: \(url)")
//                        }
//                    })
                    // END Download URL
                    
                }
            }
            
            
            
            
        } else {
            LogCustom.log(mensagem: "Não foi possível recuperar imagem do didFinishPickingMediaWithInfo")
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
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
        self.imagem.layer.borderWidth = 1
        self.imagem.layer.masksToBounds = false
        self.imagem.layer.borderColor = UIColor.black.cgColor
        self.imagem.layer.cornerRadius = self.imagem.frame.height/2
        self.imagem.clipsToBounds = true
    }
    
}
