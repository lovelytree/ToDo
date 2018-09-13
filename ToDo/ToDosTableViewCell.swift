//
//  ToDosTableViewCell.swift
//  ToDo
//
//  Created by yolanda on 9/7/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import UIKit

class ToDosTableViewCell: UITableViewCell {

    @IBOutlet var status_image: UIImageView!
    
    @IBOutlet var item: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
