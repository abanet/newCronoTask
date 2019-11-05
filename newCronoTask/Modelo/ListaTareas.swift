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
  
  @Published var tareas: [Tarea]
  
  let nombresTareas = ["Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS", "Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS"]
  
  
  init() {
    //self.tareas = [Tarea]()
    tareas = nombresTareas.map { Tarea(nombre: $0)}
  }
}
