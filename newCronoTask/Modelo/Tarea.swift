//
//  Tarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

struct Tarea: Identifiable {
  let id = UUID()
  var nombre: String
  var tiempo: String
  var seleccionada: Bool
  
  init() {
    self.nombre = ""
    self.seleccionada = false
    self.tiempo = "00:00:00"
  }
  
  init(nombre: String) {
    self.init()
    self.nombre = nombre
  }
  
  mutating func setNombre(_ nombre: String) {
    self.nombre = nombre
  }
  
  mutating func toggle() {
    self.seleccionada = !self.seleccionada
  }
  
  mutating func setSeleccionada(to nuevoValor: Bool) {
    self.seleccionada = nuevoValor
  }
}
