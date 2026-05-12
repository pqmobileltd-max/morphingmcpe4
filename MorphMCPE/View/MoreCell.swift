//
//  MoreCell.swift
//  MorphMCPE
//
//  Created by son on 23/7/25.
//

import UIKit

class MoreCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }

}
