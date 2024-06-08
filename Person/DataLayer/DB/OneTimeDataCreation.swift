//
//  OneTimeDataCreation.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  Created this file to create sort of a databse of people in the UserDefaults,
//  just to replicate the Database part
//  Gets created and executes the Data Creation part only once on first Launch
//

import UIKit

final class OneTimeDataCreation {
  
  static var shared: OneTimeDataCreation? = OneTimeDataCreation()
  
  private var dataInitialised: Bool {
    get {
      UserDefaults.standard.bool(forKey: String(describing: self))
    }
    set {
      UserDefaults.standard.set(newValue, forKey: String(describing: self))
      UserDefaults.standard.synchronize()
    }
  }
  
  private init?() {
    guard dataInitialised == false else {
      return nil
    }
  }
  
  func processData() {
    guard let peopleData = fetchPeopleData() else {
      return
    }
    
    writeDataToUserDefaults(peopleData)
  }
  
  private func fetchPeopleData() -> Data? {
    guard let asset = NSDataAsset(name: Constant.Data.dataSetName, bundle: Bundle.main) else {
      dataInitialised = false
      return nil
    }
    return asset.data
  }
  
  private func writeDataToUserDefaults(_ data: Data) {
    UserDefaults.standard.set(data, forKey: Constant.Data.peopleDataKey)
    guard UserDefaults.standard.synchronize() else {
      dataInitialised = false
      return
    }
    cleanup()
  }
  
  private func cleanup() {
    dataInitialised = true
    OneTimeDataCreation.shared = nil
  }
}
