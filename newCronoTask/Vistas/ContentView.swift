//
//  ContentView.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject  var listaTareas: ListaTareas = ListaTareas()
  @ObservedObject var reloj = Reloj()
  
  var body: some View {
    NavigationView {
      ZStack {
        Color(UIColor(named: "background")!)
          .edgesIgnoringSafeArea(.all)
          .layoutPriority(1.0)
        
        VStack {
          HStack {
            Text(reloj.tiempo)
              .tracking(2.0)
              .font(.system(.title, design: .monospaced))
              .multilineTextAlignment(.trailing)
              .padding([.leading, .trailing])
            Spacer()
          }
          List  {
            Section(header: Text("cabecera"), footer: Text("pie de tabla")) {
              ForEach(0..<listaTareas.tareas.count) { i in
                VistaTarea(tarea: self.listaTareas.tareas[i])
                .onTapGesture {
                  self.eliminarSeleccion()
                  self.listaTareas.tareas[i].toggle()
                }
              }
              
              .onDelete(perform: deleteTarea)
              .onMove(perform: moveTarea)
            }
          }
          .listStyle(GroupedListStyle())
          .navigationBarTitle(Text("Crono Task"))
          .navigationBarItems(trailing: EditButton().padding())
          
          
        }
       
        VStack {
          Spacer()
          Button(action: addTarea) {
            Image(systemName: "plus")
          }
          .padding()
          .background(Color(.blue))
          .foregroundColor(Color(.white))
          .mask(Circle())
        }
        
      }
      
    }
    
  }
  
  init() {
    UITableView.appearance().separatorColor = .clear
    UITableView.appearance().backgroundColor = UIColor(named: "background")
    UITableViewCell.appearance().backgroundColor = UIColor(named: "background")
    self.reloj.iniciarCronometro()
  }
  
  func addTarea() {
    self.listaTareas.tareas.insert(Tarea(nombre: "Nueva tarea"), at: 0)
  }
  
  func deleteTarea(at offset: IndexSet) {
    self.listaTareas.tareas.remove(atOffsets: offset)
  }
  
  func moveTarea(from source: IndexSet, to destination: Int) {
    self.listaTareas.tareas.move(fromOffsets: source, toOffset: destination)
  }
  
  func eliminarSeleccion() {
    for i in 0..<(listaTareas.tareas.count - 1) {
      listaTareas.tareas[i].setSeleccionada(to: false)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


