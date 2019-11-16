//
//  Rejol.swift
//  cronoTask
//
//  Created by Alberto Banet on 29/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation


enum PosicionesSeparadoresReloj: Int {
    case primerSeparador = 2
    case segundoSeparador = 5
}

enum TipoReloj {
    case horaMinutosSegundos
    case minutosSegundosDecimas
}


// Clase Reloj
// Encargada de mantener las cadenas de tiempos

// Estructura de tiempos:
//      00:00,00 No se ha llegado a 60 minutos
//      00:00:00 Cuando se pasan los 60 minutos. // TODO

class Reloj {
  
    var tipo: TipoReloj = TipoReloj.minutosSegundosDecimas
    var tiempo: String {
        didSet {
            tipo = tipoReloj()
            horas = horasInt()
            minutos = minutosInt()
            segundos = segundosInt()
            centesimas = centesimasInt()
        }
    }
    
    private var timer: Timer = Timer()
    private var centesimas: Int = 0
    private var segundos: Int = 0
    private var minutos: Int = 0
    private var horas: Int = 0
    
    init() {
        self.tiempo = "00:00,00" // Estado inicial de un reloj nuevo
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    init(tiempo:String) {
        self.tiempo = tiempo
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    init(horas: Int, minutos:Int, segundos: Int, centesimas: Int) {
        self.horas = horas
        self.minutos = minutos
        self.segundos = segundos
        self.centesimas = centesimas
        if horas == 0 {
            self.tipo = TipoReloj.minutosSegundosDecimas
        } else {
            self.tipo = TipoReloj.horaMinutosSegundos
        }
        self.tiempo = ""
        self.tiempo = generarCadenaTiempoCompletadaConCeros(h: horas, m: minutos, s: segundos, c: centesimas, deTipo: self.tipo)
    }
    
    // Poner reloj a cero
    func resetearReloj() {
        self.tiempo = "00:00,00" 
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    func aCero() -> Bool {
        let suma = horas + minutos + segundos + centesimas
        return suma == 0
    }
    
    func actualizaTiemposReloj() {
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    func incrementarTiempoUnaCentesima() {
            centesimas = centesimas + 1
            if centesimas == 100 {
                centesimas = 0
                segundos = segundos + 1
                if segundos == 60 {
                    segundos = 0
                    minutos = minutos + 1
                    if minutos == 60 {
                        minutos = 0
                        horas = horas + 1
                    }
                    
                }
                
            }
        
        // Generamos la nueva cadena
        self.tiempo = generarCadenaTiempoCompletadaConCeros(h: horas,m: minutos,s: segundos,c: centesimas, deTipo:self.tipo)
        self.actualizaTiemposReloj()
    }
    
    private func generarCadenaTiempoCompletadaConCeros(h:Int,m:Int,s:Int,c:Int, deTipo tipo: TipoReloj) ->String {
        // Generamos la nueva cadena
        let horasCompletadas, minutosCompletados, segundosCompletados, centesimasCompletadas: String
        
        if String(h).count == 1 {
            horasCompletadas = "0\(h)"
        } else { horasCompletadas = "\(h)" }
        
        if String(m).count == 1 {
            minutosCompletados = "0\(m)"
        } else { minutosCompletados = "\(m)" }
        
        if String(s).count == 1 {
            segundosCompletados = "0\(s)"
        } else { segundosCompletados = "\(s)" }
        
        if String(c).count == 1 {
            centesimasCompletadas = "0\(c)"
        } else { centesimasCompletadas = "\(c)" }
        
        var resultado: String
        if tipo == .horaMinutosSegundos {
            resultado = "\(horasCompletadas):\(minutosCompletados):\(segundosCompletados)"
        } else {
            resultado = "\(minutosCompletados):\(segundosCompletados),\(centesimasCompletadas)"
        }
        return resultado
    }
    
    
    // Identificación del tipo de reloj que estamos tratando
    private func tipoReloj()->TipoReloj {
        let indice = self.tiempo.index(self.tiempo.startIndex, offsetBy: PosicionesSeparadoresReloj.segundoSeparador.rawValue)
        return (self.tiempo[indice] == ",") ? TipoReloj.minutosSegundosDecimas : TipoReloj.horaMinutosSegundos
    }
    
    // Funciones que extraen el tiempo de las cadenas
    private func horasInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let indice = tiempo.index(tiempo.startIndex, offsetBy:2)
            return Int(tiempo.substring(to: indice))!
        } else {
            return 0
        }
    }
    
    private func minutosInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let start = tiempo.index(tiempo.startIndex, offsetBy:3)
            let end   = tiempo.index(tiempo.startIndex, offsetBy:4)
            return Int(tiempo[start...end])!
        } else {
            let indice = tiempo.index(tiempo.startIndex, offsetBy:2)
            return Int(tiempo.substring(to: indice))!
        }
    }
    
    private func segundosInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let indice = tiempo.index(tiempo.endIndex, offsetBy: -2)
            return Int(tiempo.substring(from: indice))!
        } else {
            let start = tiempo.index(tiempo.startIndex, offsetBy:3)
            let end   = tiempo.index(tiempo.startIndex, offsetBy:4)
            return Int(tiempo[start...end])!
        }

    }
    
    private func centesimasInt() -> Int {
        if tipo == .horaMinutosSegundos {
            return 0
        } else {
            let indice = tiempo.index(tiempo.endIndex, offsetBy: -2)
            return Int(tiempo.substring(from: indice))!
        }
    }
    
    
    class func sumarTiempos(t1:String, t2:String) -> String {
            let r1 = Reloj(tiempo: t1)
            let r2 = Reloj(tiempo: t2)
            let suma = Reloj.sumar(reloj1: r1, reloj2: r2)
            return suma.tiempo
    }
    
   class func sumar(reloj1: Reloj, reloj2: Reloj) -> Reloj {
        // sumamos centésimas
        let centesimasTotal = (reloj1.centesimas+reloj2.centesimas)%100
        var mellevo = Int((reloj1.centesimas+reloj2.centesimas)/100)
        
        let segundosTotal = (reloj1.segundos+reloj2.segundos+mellevo)%60
        mellevo = Int((reloj1.segundos+reloj2.segundos+mellevo)/60)
        
        let minutosTotal = (reloj1.minutos+reloj2.minutos+mellevo)%60
        mellevo = Int((reloj1.minutos+reloj2.minutos+mellevo)/60)
        
        let horasTotal = (reloj1.horas+reloj2.horas+mellevo)%60
        mellevo = Int((reloj1.horas+reloj2.horas+mellevo)/60) // TODO: ¿contemplar días?
        
        return Reloj(horas: horasTotal, minutos: minutosTotal, segundos: segundosTotal, centesimas: centesimasTotal)
    }
    
    private func sumarNRelojes(relojes: [Reloj]) -> Reloj {
        var relojFinal = Reloj()
        for unReloj in relojes {
            relojFinal = Reloj.sumar(reloj1: relojFinal, reloj2:unReloj)
        }
        return relojFinal
    }
  
}
