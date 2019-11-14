//
//  VistaDetalleTarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 30/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct VistaOcurrencias: View {
  @ObservedObject private var tarea: Tarea
  var ocurrenciasCategorizadas: [String:[Ocurrencia]] = [:]
  var listaFechas: [String]
  
  
  var body: some View {
    NavigationView {
      ZStack {
        Color(UIColor(named: "background")!)
          .edgesIgnoringSafeArea(.all)
          .layoutPriority(1.0)
        
        VStack {
          Text("cronoTask Log")
          Text(tarea.nombre)
          //Text(tarea.calcularTiempoAcumulado())
          List{
            ForEach(self.listaFechas, id: \.self) { fecha in
              Section (header: Text(fecha)) {
              Text("hola mundo")
//              ForEach(self.ocurrenciasCategorizadas[fecha]!, id:\.self) { ocurrencia in
//                  HStack {
//                  Text("\(ocurrencia.fecha)")
//                  Text("\(ocurrencia.hora)")
//                  //Text("\(ocurrencia.reloj.tiempo)")
//                  }
//                }
              }
            }
          }
        }
      }
    }
  }
  
  init(tarea: Tarea) {
    self.tarea = tarea
    self.ocurrenciasCategorizadas = Ocurrencia.diccionarioPorFecha(tarea.ocurrencias)
    self.listaFechas = self.ocurrenciasCategorizadas.map{$0.key}
        
  }
  
}

struct VistaDetalleTarea_Previews: PreviewProvider {
  static var previews: some View {
    VistaOcurrencias(tarea: Tarea(nombre: "Nombre tarea"))
  }
}
