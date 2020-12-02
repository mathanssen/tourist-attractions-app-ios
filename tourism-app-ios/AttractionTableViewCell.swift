//
//  AttractionTableViewCell.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/28/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class AttractionTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    // Default function
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
