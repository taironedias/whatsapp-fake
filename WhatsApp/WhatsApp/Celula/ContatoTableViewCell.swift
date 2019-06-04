//
//  ContatoTableViewCell.swift
//  WhatsApp
//
//  Created by Tairone Dias on 04/06/19.
//  Copyright © 2019 DiasDevelopers. All rights reserved.
//

import UIKit

class ContatoTableViewCell: UITableViewCell {

    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
