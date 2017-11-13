//
//  CouponManageVC.swift
//  ManageCoupon
//
//  Created by Singh, Abhay on 7/5/17.
//  Copyright © 2017 SHC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct Constant {
    static let cellPadding:CGFloat = 8.0
    static let numberOfColumn:CGFloat = 2.0
}

class CouponManageVC: UICollectionViewController {
    
    var modelArray:[offer] = []
    var countNumber = 0
    var filteredArray:[offer] = []
    var countFilteredNumber = 0
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    var customSearchController: CustomSearchVC!
    var showseachBar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        populateArray()
        setupNavbarButtons()
        countNumber = modelArray.count
        collectionView?.backgroundColor = UIColor(r: 236, g: 236, b: 236)
        collectionLayout()
        setupAddButtonFloating()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(CouponCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func setupNavbarButtons() {
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 0, g: 57, b: 128)
        let profileSignInImage = UIImage(named: "Profile-loggedIn")?.withRenderingMode(.alwaysOriginal)
        let profileBarButtonItem = UIBarButtonItem(image: profileSignInImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleProfile))
        navigationItem.leftBarButtonItem = profileBarButtonItem
        showseachBar = true
        setupSearchIconAtRightBar()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func setupIconAtRightBar(){
        let searchImage = UIImage(named: "header-search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
        setupSearchIconAtRightBar()
    }
    
    func setupSearchIconAtRightBar(){
        if showseachBar {
            let searchImage = UIImage(named: "header-search")?.withRenderingMode(.alwaysOriginal)
            let searchBarButtonItem = UIBarButtonItem(image: searchImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleSearch))
            navigationItem.rightBarButtonItems = [searchBarButtonItem] //.insert(searchBarButtonItem, at: 0) //
            showseachBar = false
        }
    }
    
    
    
    func setupAddButtonFloating(){
        let width = ScreenSize.SCREEN_WIDTH
        let addFloatingButton: UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
            button.addTarget(self, action: #selector(addCoupon), for: .touchUpInside)
            return button
        }()
        self.view.addSubview(addFloatingButton)
        addFloatingButton.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: width - 72, bottomConstant: 16, rightConstant: 16, widthConstant: 56, heightConstant: 56)
    }
    
    
    func addCoupon(){
        print("add button clicked")
    }

    
    func configureCustomSearchController() {
        customSearchController = CustomSearchVC(searchResultsController: self, searchBarFrame: CGRect(x:UIScreen.main.bounds.size.width/2 - 100, y:10.0, width: 200, height: 20.0), searchBarFont: UIFont(name: "Futura", size: 14.0)!, searchBarTextColor: UIColor.blue, searchBarTintColor: UIColor.white)
        customSearchController.customSearchBar.placeholder = "Type to search here ..."
        customSearchController.customSearchBar.showsCancelButton = false
        customSearchController.customSearchBar.backgroundColor = UIColor(r: 0, g: 57, b: 128)
        customSearchController.customDelegate = self
        navigationItem.titleView = customSearchController.customSearchBar
    }
    
    func handleSearch(){
        showseachBar = true
        if showseachBar {
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                self.configureCustomSearchController()
                self.navigationItem.rightBarButtonItems?.remove(at: 0)
            }) { (true) in
                self.showseachBar = false
                print("completed")
            }
        }
    }
    
    func handleProfile(){
        print("profile clicked")
    }
    
    
    private func collectionLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 8)
        //layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView!.collectionViewLayout = layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return countFilteredNumber
        }
        return countNumber
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CouponCell
        var displayArray:[offer] = []
        if shouldShowSearchResults {
            displayArray = filteredArray
        } else {
            displayArray = modelArray
        }
        let offerDiscount = displayArray[indexPath.row].offerValue
        cell.discountValue.attributedText = changeAttributedString(offerDiscount)
        cell.shortDescription.text = displayArray[indexPath.row].offerShortDescription
        cell.specificLocation.text = "online"
        cell.validity.text = "Dec'12"
        cell.storeImage.image = UIImage(named: displayArray[indexPath.row].storename!)
        cell.offerCode.text = displayArray[indexPath.row].offerCode
        cell.offerView.isHidden = true
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CouponCell
        UIView.transition(with: cell, duration: 0.8, options: .transitionFlipFromRight, animations: {
            if !(cell.showingBack) {
                cell.showingBack = true
                cell.cardView.isHidden = true
                cell.offerView.isHidden = false
            } else {
                cell.showingBack = false
                cell.cardView.isHidden = false
                cell.offerView.isHidden = true
            }
        }, completion: nil)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    private func changeAttributedString(_ offerString:String?) -> NSMutableAttributedString?{
        var offerDiscount = offerString
        let combination = NSMutableAttributedString()
        let firstFont = UIFont(name: "HelveticaNeue-Light", size: 30)
        let secondFont = UIFont(name: "HelveticaNeue-Light", size: 15)
        var desiredValue:NSAttributedString?
        var decimalPoint:String?
        if (offerDiscount?.contains("."))! {
            var offerDiscountArray = offerDiscount?.components(separatedBy: ".")
            offerDiscount = offerDiscountArray?[0]
            decimalPoint = offerDiscountArray?[1]
        }
        if (offerDiscount?.contains("%"))! {
            desiredValue = utilities.superScript(offerDiscount!, locationInt: (offerDiscount?.characters.count)!-1, length: 1, font1: firstFont!, font2: secondFont!)
        } else if (offerDiscount?.contains("$"))! {
            desiredValue = utilities.superScript(offerDiscount!, locationInt: 0, length: 1, font1: firstFont!, font2: secondFont!)
        } else {
            desiredValue = utilities.superScript(offerDiscount!, locationInt: 0, length: 0, font1: firstFont!, font2: secondFont!)
        }
        combination.append(desiredValue!)
        if decimalPoint != nil {
            let decimalDesiredValue = utilities.superScript(decimalPoint!, locationInt: 0, length: (decimalPoint?.characters.count)!, font1: firstFont!, font2: secondFont!)
            combination.append(decimalDesiredValue)
        }
        
        return combination
    }
    
    func populateArray(){
        let offer1 = offer(offerValue: "$10", offerShortDescription: "OFF ANY ONE REGULAR PRICE ITEM", storename: "lowes", offerCode: "4THJULY")
        modelArray.append(offer1)
        let offer2 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "hobbylobby", offerCode: "25OFF75")
        modelArray.append(offer2)
        let offer3 = offer(offerValue: "$5", offerShortDescription: "Off with a $30 minimum purchase", storename: "greatclips", offerCode: "30GET5")
        modelArray.append(offer3)
        let offer4 = offer(offerValue: "20%", offerShortDescription: "Off on your entire purchase of $75 or more", storename: "forever21", offerCode: "75MORE20")
        modelArray.append(offer4)
        let offer5 = offer(offerValue: "$75", offerShortDescription: "Off with a $499 minimum purchase for appliances", storename: "kohls", offerCode: "APLLIANCEOFF")
        modelArray.append(offer5)
        let offer6 = offer(offerValue: "10%", offerShortDescription: "Off with a $300 single purchase", storename: "carters", offerCode: "10OFF300")
        modelArray.append(offer6)
        let offer7 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "jcpenny", offerCode: "25OFF75")
        modelArray.append(offer7)
        let offer8 = offer(offerValue: "$2.50", offerShortDescription: "Off with one pair of socks", storename: "homedepot", offerCode: "25OFF75")
        modelArray.append(offer8)
        let offer9 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "kohls", offerCode: "25OFF75")
        modelArray.append(offer9)
        let offer10 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "walmart", offerCode: "25OFF75")
        modelArray.append(offer10)
        let offer11 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "landsend", offerCode: "25OFF75")
        modelArray.append(offer11)
        let offer12 = offer(offerValue: "$25", offerShortDescription: "Off with a $70 minimum purchase", storename: "kmart", offerCode: "25OFF75")
        modelArray.append(offer12)
    }

}

extension CouponManageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 3*Constant.cellPadding)/Constant.numberOfColumn, height: 136)
    }
    
}


extension CouponManageVC: CouponCellDeleteDelegate {
    func deleteCell(cell: CouponCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            modelArray.remove(at: indexPath.row)
            countNumber = countNumber - 1
            if shouldShowSearchResults {
                filteredArray.remove(at: indexPath.row)
                countFilteredNumber = countFilteredNumber - 1
            }
            self.collectionView?.deleteItems(at: [indexPath])
        }
    }
}

extension CouponManageVC: CustomSearchControllerDelegate {

    func didStartSearching() {
        shouldShowSearchResults = true
        //collectionView?.reloadData()
    }
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            collectionView?.reloadData()
        }
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        collectionView?.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        shouldShowSearchResults = true
        if searchText.isEmpty {
            shouldShowSearchResults = false
            collectionView?.reloadData()
        } else {
            filteredArray.removeAll()
            filteredArray = modelArray.filter({ (offer) -> Bool in
                let storeName = offer.storename
                return (storeName?.contains(searchText))!
            })
            countFilteredNumber = filteredArray.count
            // Reload the tableview.
            collectionView?.reloadData()
        }
    }
    
}

