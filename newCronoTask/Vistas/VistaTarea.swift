//
//  VistaTarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct VistaTarea: View {
  @ObservedObject var tarea: Tarea
  
  
  var body: some View {
    HStack() {
      Text(tarea.nombre)
        .foregroundColor((tarea.seleccionada) ? Color(.white) : Color(.black))
      Spacer()
      Text("time not set")
        .foregroundColor((tarea.seleccionada) ? Color(.white) : Color(.black))
    }
    .padding()
    .background((tarea.seleccionada) ? Color("fondoCeldaSeleccionada") : Color("fondoCelda"))
    .cornerRadius(10)
    
  }
}


struct VistaTarea_Previews: PreviewProvider {
  @State static var estaSeleccionada = ""
    static var previews: some View {
      VistaTarea(tarea: Tarea(nombre: "Nombre tarea"))
    }
}
