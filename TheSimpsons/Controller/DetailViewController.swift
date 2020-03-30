//
//  DetailViewController.swift
//  TheSimpsons
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var simpsonImage: UIImageView!
    var detailItem: Simpson? {
        didSet {
            configureView()
        }
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        if let detail = detailItem {
            if let nameLabel = nameLabel {
                nameLabel.text = detail.name
            }
            if let descriptionLabel = detailDescriptionLabel {
                descriptionLabel.text = detail.description
            }
            if let image = simpsonImage {
                let imageURL: URL? = URL(string: detail.imageURL)
                if let url = imageURL {
                    image.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }

    

}

