//
//  SkinCell.swift
//  MorphMCPE
//
//  Created by son on 6/8/22.
//

import UIKit

class SkinCell: UICollectionViewCell {
 
    @IBOutlet weak var watchAdView: UIView!
    @IBOutlet weak var watchAdsLabel: UILabel!
    @IBOutlet var skinImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(_ skin : Skin){
        
    }
}
