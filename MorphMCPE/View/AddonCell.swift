//
//  AddonCell.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//

import UIKit
import SDWebImage
class AddonCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    }

    func updateCell(addon : Addon){
        self.titleLabel.text = addon.title
       
        if let imageURL = addon.thumbnailURL{
            self.thumbnailImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
    }
}
