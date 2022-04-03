//
//  BluetoothTableViewCell.swift
//  BluetoothBuddy
//
//  Created by Khondwani Sikasote on 2022/04/03.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distanceAway: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
