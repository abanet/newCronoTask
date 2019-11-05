//
//  Ocurrencia.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Ocurrencia {
    var idTask: String?  // tarea a la que pertenece
    var fecha: String
    var hora: String
    var reloj: Reloj
    
    init() {
        self.reloj = Reloj()
        
        let unaFecha = Fecha()
        fecha = unaFecha.fecha
        hora = unaFecha.hora
        
    }
    
    convenience init(idTask: String) {
        self.init()
        self.idTask = idTask
    }
    
    init(idTask: String, tiempo: String) {
        self.idTask = idTask
        self.reloj = Reloj(tiempo: tiempo)
        
        let unaFecha = Fecha()
        fecha = unaFecha.fecha
        hora = unaFecha.hora
    }
    
    init(idTask: String, fecha: String, hora:String, tiempo:String) {
        self.idTask = idTask
        self.fecha = fecha
        self.hora = hora
        self.reloj = Reloj(tiempo: tiempo)
    }
  
  func actualizarFecha() {
    self.fecha = Fecha().fecha
  }
    
    // Al resetear una ocurrencia ponemos su reloj a cero y la fecha y hora se actualizan a la actual.
    func resetearOcurrencia() {
        self.reloj.resetearReloj()
        let unaFecha = Fecha()
        fecha = unaFecha.fecha
        hora = unaFecha.hora
    }
    
    
    // Dado un array de ocurrencias devuelve un diccionario cuya clave es el día y su valor un array de las ocurrencias correspondientes a la fecha dada.
    class func categorizarOcurrencias(_ ocurrencias:[Ocurrencia]) -> [[Ocurrencia]] {
        var fechaActual = ""
        var posicionActual = -1
        var resultado = [[Ocurrencia]]()
        
        for ocurrencia in ocurrencias {
            if ocurrencia.fecha == fechaActual { // seguimos en la misma clave
                resultado[posicionActual].append(ocurrencia)
            } else { // hay cambio de fecha
                posicionActual += 1
                resultado.append([Ocurrencia]())
                resultado[posicionActual].append(ocurrencia)
                fechaActual = ocurrencia.fecha
                
            }
        }
        return resultado
    }
    
    class func acumuladoOcurrenciasSeccion(_ ocurrencias:[Ocurrencia])->String {
        var relojTotal = Reloj()
        for ocurrencia in ocurrencias {
            relojTotal = Reloj.sumar(reloj1: relojTotal,reloj2: ocurrencia.reloj)
        }
        return relojTotal.tiempo
    }
    
    class func acumuladoTodasOcurrencias(_ ocurrencias:[Ocurrencia])->String {
        var relojTotal = Reloj()
        for ocurrencia in ocurrencias {
            relojTotal = Reloj.sumar(reloj1: relojTotal, reloj2: ocurrencia.reloj)
        }
        return relojTotal.tiempo
    }
  
  class func printOcurrencias(_ ocurrencias:[Ocurrencia]) {
    for ocurrencia in ocurrencias {
      print("Ocurrencia de fecha \(ocurrencia.fecha), idTask:\(ocurrencia.idTask), tiempo: \(ocurrencia.reloj.tiempo)")
    }
  }
}
