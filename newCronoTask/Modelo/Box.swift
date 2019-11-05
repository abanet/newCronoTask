//
//  Box.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 31/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

final class Box<Value> {
  var value: Value

  init(_ value: Value) {
    self.value = value
  }
}
