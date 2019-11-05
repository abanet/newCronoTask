//
//  Tarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Tarea: Identifiable, ObservableObject {
  let id = UUID() // identificador de tarea
  var idTarea: String? = nil // identificador de tarea en bbdd (nil si la tarea no existe en la bbdd)
  var nombre: String
  var tiempo: String
  var fechaCreacion: String
  var horaCreacion: String
  var fechaUltimaVezUtilizada: String
  var tiempoAcumulado: String?
  var ocurrencias: [Ocurrencia]?
  @Published var seleccionada: Bool
  
  
  init() {
    self.nombre = ""
    self.seleccionada = false
    self.tiempo = "00:00:00"
    let ahora = Fecha()
    self.fechaCreacion = ahora.fecha
    self.horaCreacion = ahora.hora
    self.fechaUltimaVezUtilizada = ahora.fecha
  }
  
  convenience init(nombre: String, fecha: String, hora: String, fechaUltimaVez: String) {
    self.init()
      self.nombre = nombre
      self.fechaCreacion = fecha
      self.horaCreacion = hora
      self.fechaUltimaVezUtilizada = fechaUltimaVez
      
  }
  
  convenience init(id: String, nombre: String, fecha: String, hora: String, fechaUltimaVez: String) {
      self.init(nombre: nombre, fecha: fecha, hora: hora, fechaUltimaVez: fechaUltimaVez)
      self.idTarea = id
  }
  
  convenience init(nombre: String) {
    self.init()
    self.nombre = nombre
  }
  
   func setNombre(_ nombre: String) {
    self.nombre = nombre
  }
  
   func toggle() {
    self.seleccionada = !self.seleccionada
  }
  
   func setSeleccionada(to nuevoValor: Bool) {
    self.seleccionada = nuevoValor
  }
}

extension Tarea: Equatable {
    static func == (lhs: Tarea, rhs: Tarea) -> Bool {
        return lhs.nombre == rhs.nombre
    }
}

extension Tarea: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
