//
//  HomeCell.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }

}
