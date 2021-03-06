//
//  ItemTableViewController.swift
//  StillUndecided
//
//  Created by 16 on 07/12/2017.
//  Copyright © 2017 Style RU Unofficial fan club. All rights reserved.
//

import UIKit
import MaterialComponents




class ItemTableViewController: UIViewController,TableViewManagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        categoryCell.categoryName.text = Data.categories[indexPath.row].CategoryName
        categoryCell.categoryIcon.image = UIImage(named: Data.categories[indexPath.row].CategoryIcon!)
        categoryCell.isUserInteractionEnabled = true
        savedCells?.append(categoryCell)
        return categoryCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.savedCategoriesView?.alpha = 0.0
        })
        
        showInputDialog(category: Data.categories[indexPath.row].CategoryName, icon: Data.categories[indexPath.row].CategoryIcon)
        

        
        
        
    }
    
    
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var wasPressed = false
    var savedBlurView: UIVisualEffectView?
    var savedAddNewButton: MDCFloatingButton?
    var savedAddNewCategoryButton: MDCFloatingButton?
    var savedFloatingButton: MDCFloatingButton?
    var savedCells: [CategoryCell]?
    var savedCategoriesView: UICollectionView?
    var savedComingSoonLabel: UILabel?
    
    
    var sectionIndexes = [Int]()
    

    
    var sectionArray = [TableViewSection]()
    fileprivate var tableViewManager: TableViewManager!
    
    var headerArray = [String]()
    
    
    private func insertItems() {
        
        sectionIndexes = []
        
        headerArray = []
        tableViewManager.removeAllSections()
        tableView.reloadData()
        
        
       
        
        sortItems()
        
        var section = TableViewSection()
        section.headerHeight = 50
        
        
        
        var previousMonth = ""
        var previousYear = ""
        
        var sectionNumber = -1
        
        for element in Data.items
        {
            
            if ((element.getMonth() != previousMonth)||(element.getYear() != previousYear))
            {
                //if new section
                
                section = TableViewSection()
                section.headerHeight = 50
                section.add(item: element)
                
                headerArray.append(Item.getMonthText(date: element.ItemDate!))
                
                tableViewManager.add(section: section)
                sectionArray.append(section)
                tableView.reloadData()
                
                
                previousMonth = element.getMonth()
                previousYear = element.getYear()
                
                
                sectionNumber += 1
                sectionIndexes.append(0)
                sectionIndexes[sectionNumber] += 1
                
            }
            else {
                tableViewManager.remove(section: section)
                section.add(item: element)
                tableViewManager.add(section: section)
                sectionArray.append(section)
                tableView.reloadData()
                sectionIndexes[sectionNumber] += 1
                
            }
        }
        Data.writeItemsToFile()
        tableView.reloadData()
        
    }
    
    func tableViewManager(_ manager: TableViewManager, headerViewForSection section: Int) -> UITableViewHeaderFooterView? {
        let headerView = manager.tableView.dequeueReusableHeaderFooterView(withIdentifier: "YetAnotherHeader") as! YetAnotherHeader
        headerView.nameLabel.text = headerArray[section]
        return headerView
    }
    
    func sortItems()
    {
        if !(Data.items.isEmpty) {
            var oldItems = Data.items
            var newItems = [Item]()
            var newestItem = oldItems[0]
            var removeIndex = 0
            var currentIndex = 0
            
            while (oldItems.count>0)
            {
                removeIndex = 0
                currentIndex = 0
                newestItem = oldItems[0]
                for element in oldItems
                {
                    if (Item.isNewer(item1: element, item2: newestItem))
                    {
                        newestItem = element
                        removeIndex = currentIndex
                    }
                    currentIndex+=1
                    
                }
                
                newItems.append(newestItem)
                oldItems.remove(at: removeIndex)
            }
            
            Data.items = newItems
        }
        
        
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        insertItems()
    }
 
    
     func tableViewManager(_ manager: TableViewManager, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, view, handler) in
            
            self.sectionArray[indexPath.section].remove(item: Data.items[indexPath.row])
            
            var shareIndex = 0
            var title = String()
            var rating = String()
            
            if (indexPath.section != 0){
                
                for i in 0...indexPath.section-1 {
                    shareIndex+=self.sectionIndexes[i]
                }
            }
            shareIndex+=indexPath.row
            
            title = Data.items[shareIndex].ItemName!
            rating = Data.items[shareIndex].ItemRating!
            
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsEndImageContext()
            
            let textToShare = "I rated «" + title + "» at " + rating + " out of 10"

            let objectsToShare = [textToShare] as [Any]
            let shareWindow = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            

            shareWindow.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            
            self.present(shareWindow, animated: true, completion: nil)
            }
            
        
    
        
        
        let shareImage = UIImage(named: "share_icon_black")?.withRenderingMode(.alwaysOriginal)
        shareAction.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.0)
        shareAction.image = shareImage
        
        
        
        
        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        return configuration
    }
    
    
     func tableViewManager(_ manager: TableViewManager, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
        
            self.sectionArray[indexPath.section].remove(item: Data.items[indexPath.row])

            var removeIndex = 0
            
            if (indexPath.section != 0){
            
                  for i in 0...indexPath.section-1 {
                      removeIndex+=self.sectionIndexes[i]
                  }
              }
                  removeIndex+=indexPath.row
            
                  Data.items.remove(at: removeIndex)
            
            self.insertItems()
            let action = MDCSnackbarMessageAction()
            let message = MDCSnackbarMessage()
            message.text = "Item was deleted"
            action.title = "That's too bad"
            message.action = action
            MDCSnackbarManager.show(message)
        }
        deleteAction.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.0)
        deleteAction.image = UIImage(named: "delete_icon_black")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableViewManager = TableViewManager(tableView: tableView)
        tableViewManager.delegate = self
        tableViewManager.register(nibModels: [Item.self])
        tableView.register(YetAnotherHeader.nib(), forHeaderFooterViewReuseIdentifier: "YetAnotherHeader")
        tableView.sectionHeaderHeight = 50
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 56
        
        
        //Floating Button
        let floatingButton = MDCFloatingButton()
        floatingButton.setImage(#imageLiteral(resourceName: "plus_icon_black"), for: .normal)
        floatingButton.sizeToFit()
        floatingButton.inkColor =  UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.26)
        floatingButton.backgroundColor = .white
        self.view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(callFABMenu), for: .touchUpInside)
        
        floatingButton.frame.origin.x = self.view.frame.width - floatingButton.frame.width - 16
        floatingButton.frame.origin.y = self.view.frame.height - floatingButton.frame.height - 16 - 49
        
        Data.startLoadItems()
        insertItems()
        
        
        
        
    }
    
    @objc func cancelBlur(sender: UITapGestureRecognizer) {
        
        
        wasPressed = false
        
        UIView.animate(withDuration: 0.3) {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.savedBlurView?.alpha = 0
        }
        
        
        
        UIView.animate(withDuration: 0.2) {
            self.savedAddNewButton?.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.035, options: [], animations: {
            self.savedAddNewCategoryButton?.alpha = 0
            self.savedComingSoonLabel?.alpha = 0
        })
        
        UIView.animate(withDuration: 0.15, animations: {
            self.savedFloatingButton?.alpha = 1.0
            self.savedFloatingButton?.transform = CGAffineTransform(rotationAngle: 0)
        })
        
        
    
    }
    
    @objc func callFABMenu(sender: MDCFloatingButton){
        savedFloatingButton = sender
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
 
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let addNewButton = MDCFloatingButton()
        let addNewCategoryButton = MDCFloatingButton()
        let comingSoonLabel = UILabel()
        
        
        
        if wasPressed==false {
            
            wasPressed = true
            
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0)
            
            view.insertSubview(blurEffectView, belowSubview: sender)
            savedBlurView = blurEffectView
            let tap = UITapGestureRecognizer(target: self, action: #selector(cancelBlur))
            savedBlurView?.addGestureRecognizer(tap)
            blurEffectView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.1)
                blurEffectView.alpha = 1.0
                
            }
            
            UIView.animate(withDuration: 0.15, animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            })
            
            
            
            
            addNewCategoryButton.setImage(#imageLiteral(resourceName: "category_icon_black"), for: .normal)
            addNewCategoryButton.frame.size = CGSize(width: 40, height: 40)
            addNewCategoryButton.inkColor =  UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.26)
            addNewCategoryButton.backgroundColor = .white
            self.view.insertSubview(addNewCategoryButton, belowSubview: addNewButton)
            addNewCategoryButton.frame.origin.x = self.view.frame.width - addNewCategoryButton.frame.width - 24
            addNewCategoryButton.frame.origin.y = self.view.frame.height - addNewCategoryButton.frame.height - sender.frame.height - 8 - 49
            savedAddNewCategoryButton = addNewCategoryButton;
            addNewCategoryButton.alpha = 0
            
            comingSoonLabel.text = "Coming Soon"
            comingSoonLabel.textColor = .white
            comingSoonLabel.font = comingSoonLabel.font.withSize(12)
            comingSoonLabel.textAlignment = .right
            comingSoonLabel.frame.size = CGSize(width: 100, height: 40)
            comingSoonLabel.alpha = 0
            comingSoonLabel.frame.origin.x = self.view.frame.width - addNewCategoryButton.frame.width * 2 - 24 - 8 - 65
            comingSoonLabel.frame.origin.y = self.view.frame.height - addNewCategoryButton.frame.height - sender.frame.height - 8 - 49
            savedComingSoonLabel = comingSoonLabel
            self.view.insertSubview(comingSoonLabel, belowSubview: sender)
            
            UIView.animate(withDuration: 0.2) {
                addNewCategoryButton.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
                comingSoonLabel.alpha = 1.0
                
                
                
            })
            
            
            addNewButton.setImage(#imageLiteral(resourceName: "star_icon_black"), for: .normal)
            addNewButton.frame.size = CGSize(width: 40, height: 40)
            addNewButton.inkColor =  UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.26)
            addNewButton.backgroundColor = .white
            self.view.insertSubview(addNewButton, belowSubview: sender)
            addNewButton.frame.origin.x = self.view.frame.width - addNewButton.frame.width - 24
            addNewButton.frame.origin.y = self.view.frame.height - addNewButton.frame.height - addNewButton.frame.height - sender.frame.height - 24 - 49
            addNewButton.addTarget(self, action: #selector(callCategoriesWindow), for: .touchUpInside)
            savedAddNewButton = addNewButton
            
            addNewButton.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.035, options: [], animations: {
                addNewButton.alpha = 1.0
                
                
                
            })
            
            
            
            
            
        } else {
            
            wasPressed = false
            
            
            
            UIView.animate(withDuration: 0.3) {
                UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
                self.savedBlurView?.alpha = 0
            }
            
            
            
            UIView.animate(withDuration: 0.2) {
                self.savedAddNewButton?.alpha = 0
            }
            
            UIView.animate(withDuration: 0.2) {
                self.savedCategoriesView?.alpha = 0
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.035, options: [], animations: {
                self.savedAddNewCategoryButton?.alpha = 0
                self.savedComingSoonLabel?.alpha = 0
            })
            
            UIView.animate(withDuration: 0.15, animations: {
                sender.transform = CGAffineTransform(rotationAngle: 0)
            })
            
            
        }
        
        
        
    }
    
    
    @objc func callCategoriesWindow(sender: UIButton){
        UIView.animate(withDuration: 0.2) {
            self.savedAddNewButton?.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.035, options: [], animations: {
            self.savedAddNewCategoryButton?.alpha = 0
            self.savedComingSoonLabel?.alpha = 0.0
        })
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 52, bottom: 50, right: 52)
        layout.itemSize = CGSize(width: 54, height: 80)
        
        
        let categoriesView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoriesView.dataSource = self
        categoriesView.delegate = self
        categoriesView.register(CategoryCell.nib(), forCellWithReuseIdentifier: "CategoryCell")
        categoriesView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.0)
        categoriesView.alpha = 0
        categoriesView.center = self.view.center
        categoriesView.frame.origin.x = self.view.frame.width/2 - categoriesView.frame.width/2
        categoriesView.frame.origin.y = 0
        categoriesView.allowsSelection = true
        categoriesView.isUserInteractionEnabled = true
        view.insertSubview(categoriesView, belowSubview: sender)
        savedCategoriesView = categoriesView
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            categoriesView.alpha = 1.0
        })
        
        
    }
    
    func showInputDialog(category: String?, icon: String?) {

        let alertController = UIAlertController(title: "New item", message: "Enter name and rating", preferredStyle: .alert)
        

        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let date = formatter.string(from: currentDate)
            
      
            let name = alertController.textFields?[0].text
            let rating = alertController.textFields?[1].text
            if ((Int(rating!) !=  nil)&&(Int(rating!)! > -1)&&((Int(rating!)! < 11)||(Int(rating!)! == 12)))
            {
                let newItem = Item()
                newItem.ItemName = name
                newItem.ItemDate = date
                newItem.ItemIcon = icon
                newItem.ItemCategory = category
                newItem.ItemRating = rating
                
                Data.items.append(newItem)
                self.tableView.reloadData()
                self.insertItems()
                Data.writeItemsToFile()
                
                
                self.wasPressed = false
            } else {
                let message = MDCSnackbarMessage()
                message.text = "Please, enter a number on a scale from 0 to 10"
                let action = MDCSnackbarMessageAction()
                action.title = "Oh I'm sorry"
                message.action = action
                MDCSnackbarManager.show(message)
            }
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                self.savedBlurView?.alpha = 0.0
                self.savedFloatingButton?.alpha = 1.0
                self.savedFloatingButton?.transform = CGAffineTransform(rotationAngle: 0)
            })
            
            
            
            
        }
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                self.savedBlurView?.alpha = 0.0
                self.savedFloatingButton?.alpha = 1.0
                self.savedFloatingButton?.transform = CGAffineTransform(rotationAngle: 0)
            })
            self.wasPressed = false
            
            
        }
        

        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Rating"
        }
        

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        

        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //
    //        return Item.calculateMonths(items: items)
    //
    //    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return itemArray[section].count
    //    }
    
    
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = tableView.dequeueReusableCell(withIdentifier: "TableSectionHeader") as? TableSectionHeader
    //        dump(months)
    //        headerView?.SectionHeader.text = months[section]
    //        return headerView
    //    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        // Table view cells are reused and should be dequeued using a cell identifier.
    //        let cellIdentifier = "ItemTableViewCell"
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
    //            fatalError("something happened")
    //        }
    //        print(indexPath.section,"thiiiiSsmth ",indexPath.row)
    //        let item = itemArray[indexPath.section][indexPath.row]
    //
    //        cell.NameLabel.text = item.ItemName
    //        cell.CategoryLabel.text = item.ItemCategory
    //        cell.RatingLabel.text = String(item.ItemRating)
    //        cell.CategoryIcon.image = item.ItemIcon
    //        cell.StarIcon.image = item.ItemStarIcon
    //
    //
    //
    //
    //        return cell
    //    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //    private func loadItems() {
    //        let photo1 = #imageLiteral(resourceName: "movie_icon_white")
    //        let photo2 = #imageLiteral(resourceName: "book_icon_white")
    //        let photo3 = #imageLiteral(resourceName: "cafe_icon_white")
    //
    //
    //        guard let item1 = Item(ItemName: "League of Justice", ItemRating: 4, ItemCategory: "Movie", ItemIcon: photo1, ItemStarIcon: #imageLiteral(resourceName: "star_icon_white"), ItemDate: "11.11.2017") else {
    //            fatalError("Unable to instantiate item")
    //        }
    //
    //        guard let item2 = Item(ItemName: "The Unbearable Lightness of Being", ItemRating: 10, ItemCategory: "Book", ItemIcon: photo2, ItemStarIcon: #imageLiteral(resourceName: "star_icon_white"), ItemDate: "15.12.2017") else {
    //            fatalError("Unable to instantiate item")
    //        }
    //
    //        guard let item3 = Item(ItemName: "Rozetka i Kofe", ItemRating: 4, ItemCategory: "Cafe", ItemIcon: photo3, ItemStarIcon: #imageLiteral(resourceName: "star_icon_white"), ItemDate: "18.12.2017") else {
    //            fatalError("Unable to instantiate item")
    //        }
    //
    //        items += [item1, item2, item3]
    //        print(Item.calculateMonths(items: items))
    //
    //        itemArray = Item.getArray(items: items)
    //        months = Item.monthList(items: items)
    //    }
    
}
