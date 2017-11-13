//
//  CouponCell.swift
//  ManageCoupon
//
//  Created by Singh, Abhay on 7/5/17.
//  Copyright © 2017 SHC. All rights reserved.
//

import UIKit

protocol CouponCellDeleteDelegate: class {
    func deleteCell(cell: CouponCell)
}

class CouponCell: UICollectionViewCell {
    
    var showingBack = false
    weak var delegate: CouponCellDeleteDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        setupOfferView()
        setupCardView()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 3
        doubleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTap)
        self.isUserInteractionEnabled = true
        doubleTap.delaysTouchesBegan = true
    }
    
    func doubleTapped() {
        delegate?.deleteCell(cell: self)
    }
    
    private func setupCardViewComponents(){
        cardView.addSubview(storeImage)
        cardView.addSubview(discountValue)
        cardView.addSubview(shortDescription)
        cardView.addSubview(specificLocation)
        cardView.addSubview(validity)
        
        storeImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        
        discountValue.anchor(topAnchor, left: storeImage.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 40)
        
        shortDescription.anchor(storeImage.bottomAnchor, left: storeImage.leftAnchor, bottom: nil, right: discountValue.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        specificLocation.anchor(shortDescription.bottomAnchor, left: shortDescription.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: (self.frame.width - 20)/2, heightConstant: 20)
        
        validity.anchor(shortDescription.bottomAnchor, left: specificLocation.rightAnchor, bottom: self.bottomAnchor, right:shortDescription.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 20)
    }
    
    private func setupOfferViewComponents(){
        offerView.addSubview(offerCode)
        offerCode.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 20, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupCardView(){
        addSubview(cardView)
        cardView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupCardViewComponents()
    }
    
    private func setupOfferView(){
        addSubview(offerView)
        offerView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupOfferViewComponents()
    }
    
    let storeImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let discountValue:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shortDescription:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let specificLocation:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brown
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let validity:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.orange
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardView:UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(r: 254, g: 254, b: 254)
        uiView.layer.cornerRadius = 10.0
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let offerView:UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.white
        uiView.layer.cornerRadius = 10.0
        uiView.clipsToBounds = true
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let offerCode:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brown
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
