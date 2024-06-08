//
//  Constant.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//

import Foundation

enum Constant {
  enum Data {
    static var peopleDataKey: String {
      String(describing: self)
    }
    static var dataSetName: String {
      "People"
    }
  }
}
