//
//  Tarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Tarea: Identifiable, ObservableObject {
  static let origenTiempo = "00:00,00"
  let id = UUID() // identificador de tarea
  var idTarea: String? = nil // identificador de tarea en bbdd (nil si la tarea no existe en la bbdd)
  var nombre: String
  var tiempo: String
  var fechaCreacion: String
  var horaCreacion: String
  var fechaUltimaVezUtilizada: String
  @Published var tiempoAcumulado: String = Tarea.origenTiempo
  @Published var ocurrencias: [Ocurrencia] = [Ocurrencia]()
  @Published var seleccionada: Bool
  
  
  init() {
    self.nombre = ""
    self.seleccionada = false
    self.tiempo = "00:00,00"
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
  
  func resetTiempoAcumulado() {
    self.tiempo = Tarea.origenTiempo
  }
  
  func addOcurrencia(_ ocurrencia: Ocurrencia) {
    self.ocurrencias.insert(ocurrencia, at: 0)
  }
  
  // Calcular un String con el tiempo acumulado de todas las ocurrencias para añadir al acumulado de la tarea
  func calcularTiempoTotal() -> String {
    var relojFinal = Reloj()
    for unaOcurrencia in self.ocurrencias {
      relojFinal = Reloj.sumar(reloj1: relojFinal, reloj2:unaOcurrencia.reloj)
    }
    return relojFinal.tiempo
  }

  // devuelve un diccionario con las ocurrencias de la tarea clasificadas por fecha
  func diccionarioPorFecha() -> [String: [Ocurrencia]] {
    var fechaActual = ""
    var resultado = [String:[Ocurrencia]]()
    
    for ocurrencia in ocurrencias {
      if ocurrencia.fecha == fechaActual { // seguimos en la misma clave
        resultado[ocurrencia.fecha]!.append(ocurrencia)
      } else { // hay cambio de fecha
        resultado[ocurrencia.fecha] = [Ocurrencia]()
        resultado[ocurrencia.fecha]!.append(ocurrencia)
        fechaActual = ocurrencia.fecha
      }
    }
    return resultado
  }
  
  // devuelve un array con las fechas en las que esta tarea tiene ocurrencias
  func listaFechas() -> [String] {
    return self.diccionarioPorFecha().map{$0.key}
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

extension Tarea: CustomStringConvertible {
  var description: String {
    var descripcionOcurrencias: String = ""
    for ocurrencia in self.ocurrencias {
      descripcionOcurrencias += ocurrencia.fecha + "," + ocurrencia.hora + "//"
    }
    return "Tarea \(self.nombre)" + descripcionOcurrencias
  }
}
