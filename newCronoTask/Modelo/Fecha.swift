//
//  Fecha.swift
//  YourLastTime
//
//  Created by Alberto Banet Masa on 9/6/15.
//  Copyright (c) 2015 abanet. All rights reserved.
//

import UIKit

class Fecha: NSObject {
    var fecha: String
    var hora: String
    
    override init(){
        let date = Date()
        let formateador = DateFormatter()
        // El formateador de fecha lo mantenemos siempre a MM-dd-yyy para guardarlo en el mismo formato en la bbdd
        formateador.dateFormat = "MM-dd-yyyy" //NSLocalizedString("MM-dd-yyyy", comment: "Formato de fecha")
        fecha = formateador.string(from: date)
        formateador.dateFormat = "HH:mm"
        hora = formateador.string(from: date)
        super.init()
    }
    
    class func devolverFechaLocalizada(fecha: String)-> String?{
        let formateador = DateFormatter()
        // se guardó en formato MM-dd-yyyy
        formateador.dateFormat = "MM-dd-yyyy"
        let date = formateador.date(from: fecha)
        // formato en el que mostraremos la fecha
        formateador.dateFormat = NSLocalizedString("MM-dd-yyyy", comment: "Formato de fecha")
        return formateador.string(from: date!)
    }
    
    // dada una fecha en formato MM-dd-yyy se devuelve el literal localizado: Lunes, 10 de octubre de 2016.
    func literalFechaLocalizada(fecha: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"identificadorLocalFecha".localized)
        formatter.dateStyle = .full
        let fechaNSDate = self.fechaStringToDate(fecha: fecha)
        return formatter.string(from:fechaNSDate)
    }
    
    func fechaStringToDate(fecha: String)->Date{
        // IMPORTANTE: Se supone que el formato en que se pasa la fecha es el original en el que está grabada.
        let formateador = DateFormatter()
        formateador.dateFormat = "MM-dd-yyyy"
        let fechaTemp = formateador.date(from: fecha)
        return fechaTemp!
    }
    
    // fecha completa: fecha con  hora incluida.
    func fechaCompletaStringToDate(fechaCompleta: String) -> Date {
        let formateador = DateFormatter()
        formateador.dateFormat = "MM-dd-yyyyHH:mm"
        let fechaTemp = formateador.date(from: fechaCompleta)
        return fechaTemp!
    }
    
    private func intervalo(dias:Int)->TimeInterval {
        return TimeInterval(dias * 24 * 60 * 60)
    }
    
    
}

