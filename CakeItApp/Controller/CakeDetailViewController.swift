//
//  CakeDetailViewController.swift
//  CakeItApp
//
//  Created by David McCallum on 21/01/2021.
//

import UIKit

class CakeDetailViewController: UIViewController {
    
    @IBOutlet private weak var cakeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var cake: Cake?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Cake Title"
        descriptionLabel.text = "Cake description"
        
        if let cake = self.cake {
            titleLabel.text = cake.title
            descriptionLabel.text = cake.desc
            cakeImageView.image = cake.image
        }
    }
}
