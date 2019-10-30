//
//  ListaTareas.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import Combine

class ListaTareas: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  var tareas: [Tarea] {
    didSet {
      didChange.send()
    }
  }
  
  let nombresTareas = ["Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS", "Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS"]
  
  
  init() {
    tareas = nombresTareas.map { Tarea(nombre: $0)}
  }
}
