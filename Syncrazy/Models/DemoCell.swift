//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import FoldingCell
import UIKit
//protocol restuarantCell {
//    func sendYelpLogoTapped()
//}
class DemoCell: FoldingCell {
    
    
    //Mark: IBOutlets
    
    @IBOutlet weak var titleOfTheRestaurant: UILabel!
    @IBOutlet weak var titleOfTheRestaurantOpenCell: UILabel!
    @IBOutlet weak var addressPt1: UILabel!
    @IBOutlet weak var addressPt2: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
     @IBOutlet weak var exprensiveLabel: UILabel!
     @IBOutlet weak var outsideRatingLabel: UILabel!
    @IBOutlet weak var outsidePriceLabel: UILabel!
      @IBOutlet weak var outsideReviewCountLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet var yelpLogoTapped: UIButton!
    //var delegate: groupCellDelegate?
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension DemoCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
