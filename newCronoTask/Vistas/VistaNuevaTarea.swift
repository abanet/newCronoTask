//
//  VistaNuevaTarea.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 04/11/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct VistaNuevaTarea: View {
  
  @Binding var nombre: String 
  @Binding var mostrarNuevaTarea: Bool
  var onDismiss: () -> ()
  
  var body: some View {
    VStack {
      Text("Named your new task")
        .font(.system(.title))
        .padding()
      
      TextField("Type the name...", text: $nombre)
        .font(.system(.subheadline))
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.white.opacity(0.4), radius: 3, x: 1, y: 2)
      
      HStack {

        Button(action: {
//self.mostrarNuevaTarea = false
          self.nombre = ""
          self.onDismiss()
        }) {
          Text("👎")
            .font(.largeTitle)
            .padding()
        }
        .background(Color(.white).opacity(0.5))
        .cornerRadius(5)
        .padding()
        
        Button(action: {
          //self.mostrarNuevaTarea = false
          self.onDismiss()
        }) {
          Text("👍")
            .font(.largeTitle)
            .padding()
        }
        .background(Color(.white).opacity(0.5))
        .cornerRadius(5)
        .padding()
      }.padding()
      
      Spacer()
    }
    .padding()
    .background(Color(UIColor(named: "background")!))
  
  }
 
}


struct VistaNuevaTarea_Previews: PreviewProvider {
  @State var nombre: String = "Nombre de prueba"
  static var previews: some View {
    VistaNuevaTarea(nombre: .constant(""), mostrarNuevaTarea: .constant(false), onDismiss: {print("hola")})
  }
}
