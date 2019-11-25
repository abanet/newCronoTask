//
//  VistaDetalleTarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 30/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct VistaOcurrencias: View {
  @EnvironmentObject var ddbb: TaskDatabase
 
  let tarea: Tarea
 
  
  var body: some View {
      ZStack {
        Color(UIColor(named: "background")!)
          .edgesIgnoringSafeArea(.all)
          .layoutPriority(1.0)
        
        VStack {
          HStack {
            Text("Total: " + tarea.calcularTiempoTotal()).tracking(2.0)
            .font(.system(.headline, design: .monospaced))
            .foregroundColor(.white)
            .multilineTextAlignment(.trailing)
            Spacer()
          }
          .padding([.leading])
          List{
            ForEach(self.tarea.listaFechas(), id: \.self) { fecha in
              Section (header: Text(fecha).foregroundColor(.orange)) {
                ForEach(self.tarea.diccionarioPorFecha()[fecha]!, id:\.self) { ocurrencia in
                  HStack {
                  Text("\(ocurrencia.hora)")
                  Text("\(ocurrencia.reloj.tiempo)")
                  }
                }
                .onDelete { self.delete(at: $0, fecha: fecha) }
              }
            }
          }
        }
        .navigationBarTitle("\(tarea.nombre) Log")
    }
  }
  
  
  func delete(at: IndexSet, fecha: String) {
    print("intentando borrar en index: \(at.first!) de fecha: \(fecha)")
  }
  
  func deleteOcurrencia(at offset: IndexSet) {
    let ocurrencia = self.tarea.ocurrencias[offset.first!]
    self.tarea.ocurrencias.remove(atOffsets: offset)
    self.ddbb.removeOcurrencia(ocurrencia)
  }
  
  
}

struct VistaDetalleTarea_Previews: PreviewProvider {
  static var previews: some View {
    
    VistaOcurrencias(tarea: Tarea(nombre: "Nombre tarea"))
  }
}
