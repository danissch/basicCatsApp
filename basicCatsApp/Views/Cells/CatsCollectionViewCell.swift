//
//  CatsCollectionViewCell.swift
//  basicCatsApp
//
//  Created by Daniel Duran Schutz on 20/05/23.
//

import Foundation
import UIKit
import SDWebImage

class CatsCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var origin: UILabel!
    
    @IBOutlet weak var intelligence: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(title:String, imageUrl:String = "", origin:String, intelligence:String){
        self.title.text = title
        self.origin.text = origin
        self.intelligence.text = intelligence
    
        image.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
    }
    
    
    
    
    
    override func prepareForReuse() {
        self.image.image = nil // or placeholder image
        super.prepareForReuse()
    }
    
}
