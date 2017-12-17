//
//  Data.swift
//  StillUndecided
//
//  Created by Igor on 17/12/2017.
//  Copyright © 2017 Anonim. All rights reserved.
//

import Foundation



class Data {
    static var items = [Item]()
    static var categories = [Category]()
    
    
    static func classToStruct(items: [Item]) -> [ItemData]{
        var data = [ItemData]()
        var dataItem = ItemData()
        for item in items {
            dataItem = ItemData()
            dataItem.ItemName = item.ItemName
            dataItem.ItemRating = item.ItemRating
            dataItem.ItemCategory = item.ItemCategory
            dataItem.ItemIcon = item.ItemIcon
            dataItem.ItemDate = item.ItemDate
            data.append(dataItem)
        }
        return data
    }
    
    static func classToStruct(categories: [Category]) -> [CategoryData]{
        var data = [CategoryData]()
        var dataItem = CategoryData()
        for item in categories {
            dataItem = CategoryData()
            dataItem.CategoryName = item.CategoryName
            dataItem.CategoryIcon = item.CategoryIcon
            data.append(dataItem)
        }
        return data
    }
    
    
    
    //    func structToClass(data: [ItemData]) -> [Item]{
    //        var items = [Item]()
    //        var item = Item()
    //        for dataItem in data {
    //            item = Item()
    //            item.ItemName = dataItem.ItemName
    //            item.ItemRating = dataItem.ItemRating
    //            item.ItemCategory = dataItem.ItemCategory
    //            item.ItemIcon = dataItem.ItemIcon
    //            item.ItemDate = dataItem.ItemDate
    //            items.append(item)
    //        }
    //
    //        return items
    //    }
    
    static func writeItemsToFile() {
        //definng array
        var itemDataArray = classToStruct(items: items)
        //serealizing
        let itemDataDic = itemDataArray.map { $0.convertToDictionary() }
        
        var str = String()
        
        if let itemData = try? JSONSerialization.data(withJSONObject: itemDataDic, options: .prettyPrinted) {
            str = String(bytes: itemData, encoding: .utf8)!
        }
        
        //writing to file
        let fileName = "data"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
        
        do {
            // Write to the file
            try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Oshybka 1")
        }
    }
    
    static func writeCategoriesToFile() {
        //definng array
        var categoriesDataArray = classToStruct(categories: categories)
        //serealizing
        let categoryDataDic = categoriesDataArray.map { $0.convertToDictionary() }
        
        var str = String()
        
        if let categoryData = try? JSONSerialization.data(withJSONObject: categoryDataDic, options: .prettyPrinted) {
            str = String(bytes: categoryData, encoding: .utf8)!
        }
        
        //writing to file
        let fileName = "categories"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
        
        do {
            // Write to the file
            try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Oshybka 1")
        }
    }
    
    static func startLoadItems() {
        

        
        //items:
        //reading
        let fileName = "data"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Mistake 2")
        }
        
        //to dict
        let jsonData = readString.data(using: .utf8)
        
        var newItems = [Item]()
        var newItem = Item()
        
        
        
        if let jsonDataArray = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String: Any]] {
            for dataElement in jsonDataArray! {
                newItem = Item()
                newItem.ItemName = dataElement["ItemName"] as! String
                newItem.ItemRating = dataElement["ItemRating"] as! String
                newItem.ItemCategory = dataElement["ItemCategory"] as! String
                newItem.ItemIcon = dataElement["ItemIcon"] as! String
                newItem.ItemDate = dataElement["ItemDate"] as! String
                newItems.append(newItem)
            }
        }
        items = newItems
        
        startLoadCategories()
    }
    
    static func startLoadCategories() {
        loadTestCategories()
        
        
        //reading
        let fileName = "categories"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Mistake 2")
        }
        
        //to dict
        let jsonData = readString.data(using: .utf8)
        
        var newCategories = [Category]()
        var newCategory = Category()
        
        
        
        if let jsonDataArray = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String: Any]] {
            for dataElement in jsonDataArray! {
                newCategory = Category(CategoryName: dataElement["CategoryName"] as! String)
                newCategories.append(newCategory)
            }
        }
        //categories = newCategories
    }
    
    static func loadTestCategories(){
        var category = Category(CategoryName: "Airport")
        categories.append(category)
        
        category = Category(CategoryName: "Album")
        categories.append(category)
        
        category = Category(CategoryName: "Book")
        categories.append(category)
        
        category = Category(CategoryName: "Cafe")
        categories.append(category)
        
        category = Category(CategoryName: "Camera")
        categories.append(category)
        
        category = Category(CategoryName: "Company")
        categories.append(category)
        
        category = Category(CategoryName: "Hotel")
        categories.append(category)
        
        category = Category(CategoryName: "Laptop")
        categories.append(category)
        
        category = Category(CategoryName: "Store")
        categories.append(category)
        
        category = Category(CategoryName: "Movie")
        categories.append(category)
        
        category = Category(CategoryName: "Operator")
        categories.append(category)
        
        category = Category(CategoryName: "Restaurant")
        categories.append(category)
        
        category = Category(CategoryName: "TV Show")
        categories.append(category)
        
        category = Category(CategoryName: "Smartphone")
        categories.append(category)
        
        category = Category(CategoryName: "Song")
        categories.append(category)
        
        category = Category(CategoryName: "TV")
        categories.append(category)
        
        category = Category(CategoryName: "Videogame")
        categories.append(category)
        
        category = Category(CategoryName: "Website")
        categories.append(category)
        
    }
    
    static func loadTestData()
    {
        var item1 = Item()
        
        item1.ItemName = "League of Justice"
        item1.ItemDate = "21.11.2017"
        item1.ItemIcon = "movie_icon_white"
        item1.ItemCategory = "Movie"
        item1.ItemRating = "4"
        
        items.append(item1)
        
        
        item1 = Item()
        item1.ItemName = "War and Peace"
        item1.ItemDate = "11.12.2017"
        item1.ItemIcon = "book_icon_white"
        item1.ItemCategory = "Book"
        item1.ItemRating = "9"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "McDonald's"
        item1.ItemDate = "22.12.2017"
        item1.ItemIcon = "cafe_icon_white"
        item1.ItemCategory = "Cafe"
        item1.ItemRating = "9"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "KFC"
        item1.ItemDate = "22.10.2017"
        item1.ItemIcon = "cafe_icon_white"
        item1.ItemCategory = "Cafe"
        item1.ItemRating = "8"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "BurgerKing"
        item1.ItemDate = "22.10.2017"
        item1.ItemIcon = "cafe_icon_white"
        item1.ItemCategory = "Cafe"
        item1.ItemRating = "7"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Starbucks"
        item1.ItemDate = "22.10.2017"
        item1.ItemIcon = "cafe_icon_white"
        item1.ItemCategory = "Cafe"
        item1.ItemRating = "8"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Star Wars VIII"
        item1.ItemDate = "15.12.2017"
        item1.ItemIcon = "movie_icon_white"
        item1.ItemCategory = "Movie"
        item1.ItemRating = "10"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Spider Man: Homecoming"
        item1.ItemDate = "06.07.2017"
        item1.ItemIcon = "movie_icon_white"
        item1.ItemCategory = "Movie"
        item1.ItemRating = "10"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Republic (Plato)"
        item1.ItemDate = "19.08.2017"
        item1.ItemIcon = "book_icon_white"
        item1.ItemCategory = "Book"
        item1.ItemRating = "10"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "The Godfather"
        item1.ItemDate = "15.03.1972"
        item1.ItemIcon = "movie_icon_white"
        item1.ItemCategory = "Movie"
        item1.ItemRating = "9"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Citizen Kane"
        
        item1.ItemDate = "01.05.1941"
        item1.ItemIcon = "movie_icon_white"
        item1.ItemCategory = "Movie"
        item1.ItemRating = "10"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Slaughterhouse-Five"
        item1.ItemDate = "11.12.2017"
        item1.ItemIcon = "book_icon_white"
        item1.ItemCategory = "Book"
        item1.ItemRating = "9"
        
        items.append(item1)
        
        item1 = Item()
        item1.ItemName = "Thinking, Fast and Slow"
        item1.ItemDate = "25.10.2011"
        item1.ItemIcon = "book_icon_white"
        item1.ItemCategory = "Book"
        item1.ItemRating = "9"
        
        items.append(item1)
    }
    
}
