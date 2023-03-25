//
//  ImageCell.swift
//  StableDiffusion
//
//  Created by Sai Balaji on 25/03/23.
//

import UIKit

class ImageCell: UICollectionViewCell {

    static let CELL_ID = "IMAGE_CELL"
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(image: UIImage){
        self.imageView.image = image
    }

}
