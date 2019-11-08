//
//  VistaDetalleTarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 30/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct VistaDetalleTarea: View {
   @ObservedObject var tarea: Tarea
    var body: some View {
      Text(tarea.nombre)
    }
}

struct VistaDetalleTarea_Previews: PreviewProvider {
    static var previews: some View {
        VistaDetalleTarea(tarea: Tarea(nombre: "Nombre tarea"))
    }
}
