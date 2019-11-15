//
//  ContentView.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var ddbb: TaskDatabase
  
  @State private var existeTarea = false
  @State private var nuevaTareaNombre: String = ""
  @State private var mostrarNuevaTarea: Bool = false
  @State private var tiempoCorriendo: Bool = false // Indica si existe alguna tarea contando tiempo.
  @State private var tiempo: String = "00:00,00"
  
  let timer = MiTimer()
  let reloj = Reloj()
  
  var body: some View {
    NavigationView {
      ZStack {
        Color(UIColor(named: "background")!)
          .edgesIgnoringSafeArea(.all)
          .layoutPriority(1.0)

        VStack {
          HStack {
            Text(self.tiempo)
              .tracking(2.0)
              .font(.system(.title, design: .monospaced))
              .foregroundColor(.white)
              .multilineTextAlignment(.trailing)
              .padding([.leading, .trailing])
            
            Spacer()
          }
          List  {
            Section(
            header: Text("Press over the task to run the chrono")
              .foregroundColor(.white),
            footer: Text("Time is money. – Benjamin Franklin.")
            .foregroundColor(.white)) {
              ForEach(ddbb.tareas, id: \.self) { tarea in
               // NavigationLink(destination: VistaOcurrencias(tarea: tarea)) {
                  VistaTarea(tarea: tarea)
                    .onReceive(self.timer.currentTimePublisher) { _ in
                      if tarea.seleccionada {
                        self.reloj.incrementarTiempoUnaCentesima()
                        tarea.tiempoAcumulado = self.reloj.tiempo
                        self.tiempo = self.reloj.tiempo
                      }
                    }
                    .onTapGesture {
                      self.marcarTareasComoNoSeleccionadas(excepto: tarea)
                        tarea.toggle()
                        print("tarea está: \(tarea.seleccionada)")
                        if tarea.seleccionada {
                          self.reloj.tiempo = tarea.tiempoAcumulado
                          self.tiempoCorriendo = true
                        } else {
                          self.tiempoCorriendo = false
                        }
                    }
                  .contextMenu {
                    NavigationLink(destination: VistaOcurrencias(tarea: tarea)) {
                      Text("Log \(tarea.nombre)")
                    }
                    Button(action: {
                      // grabar ocurrencia con tiempo acumulado actual
                      self.addOcurrencia(a: tarea)
                      // self.marcarTareasComoNoSeleccionadas(excepto: nil)
                    }) {
                      Text("Save")
                      Image(systemName: "clock")
                    }
                    
                    Button(action: {
                      tarea.tiempoAcumulado = Tarea.origenTiempo
                    }) {
                      Text("Reset")
                      Image(systemName: "clear")
                    }
                }
              }
              .onDelete(perform: deleteTarea)
              .onMove(perform: moveTarea)
            }
          }
          .listStyle(GroupedListStyle())
          .navigationBarTitle(Text("Crono Task").foregroundColor(.white))
          .navigationBarItems(trailing:
            EditButton()
              .foregroundColor(.white)
              .opacity(self.tiempoCorriendo ? 0.5 : 1.0)
              .disabled(self.tiempoCorriendo)
          )
        }
        
        VStack {
          Spacer()
          Button(action: { self.mostrarNuevaTarea = true }) {
            HStack() {
              Image(systemName: "plus")
                .frame(width: 30, height: 30, alignment: .center)
                .background(Color(UIColor(named: "fondoCelda")!))
              .mask(Circle())
              .overlay(Circle().stroke(Color.orange, lineWidth: 1))
              .padding(8)
              .foregroundColor(Color(.white))
              Text("Add new task")
                .padding(.trailing, 8)
                .foregroundColor(.white)
              }
              .padding(5)
            .background(Color(UIColor(named: "background")!))
             .overlay(RoundedRectangle(cornerRadius: 190)
              .stroke(Color.orange, lineWidth: 2))
            .cornerRadius(190.0)
            .shadow(radius: 5, x: 5, y: 5)
            
            }
          
          .alert(isPresented: $existeTarea) {
            Alert(title: Text("Tarea duplicada"), message: Text("La tarea ya existe en la base de datos"), dismissButton: .default(Text("Ok")))
          }
          .sheet(isPresented: $mostrarNuevaTarea, onDismiss: {
            self.nuevaTareaNombre = ""
          }) {
            VistaNuevaTarea(nombre:  self.$nuevaTareaNombre, mostrarNuevaTarea: self.$mostrarNuevaTarea, onDismiss: {
              self.mostrarNuevaTarea = false
              print("Nombre en dismiss de vistanuevtara: \(self.nuevaTareaNombre)")
              if !self.nuevaTareaNombre.isEmpty {
                self.addTarea()
              }
            } )
            }
        }
      }
    } 
  }
  
  init() {
    UITableView.appearance().separatorColor = .clear
    UITableView.appearance().backgroundColor = UIColor(named: "background")
    UITableViewCell.appearance().backgroundColor = UIColor(named: "background")
   
  }
  
  // añade una tarea a la base de datos
  func addTarea() {
    let tarea = Tarea(nombre: "\(self.nuevaTareaNombre)")
    if self.ddbb.existeTarea(t: tarea) {
      self.existeTarea = true
    } else {
      self.ddbb.addTask(tarea: tarea)
    }
    self.nuevaTareaNombre = ""
  }
  
  // Añadir una ocurrencia a la tarea correspondiente
  // Habría que refactorizar TaskDatabase para que todo lo que cambia la base de datos esté allí
  func addOcurrencia(a tarea: Tarea) {
   // if let id = ddbb.idParaTarea(descrip: tarea.nombre) {
      let nuevaOcurrencia = Ocurrencia(idTask:tarea.nombre, tiempo: tarea.tiempoAcumulado)
      self.ddbb.addOcurrencia(nuevaOcurrencia)
      tarea.addOcurrencia(nuevaOcurrencia)
      tarea.tiempoAcumulado = Tarea.origenTiempo
  //  }
  }
  
  func deleteTarea(at offset: IndexSet) {
    print("offset: \(offset.startIndex)")
    let tarea = self.ddbb.tareas[offset.first!]
    self.ddbb.tareas.remove(atOffsets: offset)
    self.ddbb.removeTask(tarea: tarea)
  }
  
  func moveTarea(from source: IndexSet, to destination: Int) {
    self.ddbb.tareas.move(fromOffsets: source, toOffset: destination)
  }
  
  func eliminarSeleccion(excepto: Int) {
    for i in 0..<(self.ddbb.tareas.count - 1) {
      if i != excepto {
        self.ddbb.tareas[i].setSeleccionada(to: false)
      } else {
        if self.ddbb.tareas[i].seleccionada {
          self.ddbb.tareas[i].setSeleccionada(to: true)
        } else {
          self.ddbb.tareas[i].setSeleccionada(to: false)
        }
      }
    }
  }
  
  func marcarTareasComoNoSeleccionadas(excepto: Tarea?) {
    for i in 0..<(self.ddbb.tareas.count) {
      if excepto == nil  {
        self.ddbb.tareas[i].setSeleccionada(to: false)
      } else {
        if self.ddbb.tareas[i] != excepto! {
          self.ddbb.tareas[i].setSeleccionada(to: false)
        }
      }
        
    }
  }
  
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


