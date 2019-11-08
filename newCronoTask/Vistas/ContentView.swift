//
//  ContentView.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 21/10/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var ddbb: TaskDatabase
  @ObservedObject private var reloj = Reloj()
  
  @State private var existeTarea = false
  @State private var nuevaTareaNombre: String = ""
  @State private var mostrarNuevaTarea: Bool = false
  
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
                
                NavigationLink(destination: VistaDetalleTarea()) {
                  VistaTarea(tarea: tarea)
                    .onTapGesture {
                        tarea.toggle()
                        print("tarea está: \(tarea.seleccionada)")
                        if tarea.seleccionada {
                          self.reloj.iniciarCronometro()
                        } else {
                          self.reloj.pararCronometro()
                        }
                      // self.eliminarSeleccion(excepto: i)
                    }
                  .contextMenu {
                      Button(action: {
                          // change country setting
                      }) {
                          Text("Choose Country")
                          Image(systemName: "globe")
                      }

                      Button(action: {
                          // enable geolocation
                      }) {
                          Text("Detect Location")
                          Image(systemName: "location.circle")
                      }
                  }
                }

              }
                
              .onDelete(perform: deleteTarea)
              .onMove(perform: moveTarea)
            }
          }
          .listStyle(GroupedListStyle())
          .navigationBarTitle(Text("Crono Task").foregroundColor(.white))
          .navigationBarItems(trailing: EditButton())
        }
        .blur(radius: mostrarNuevaTarea ? 5 : 0)
       
//        if mostrarNuevaTarea {
//          VStack {
//            VistaNuevaTarea(nombre: $nuevaTareaNombre)
//          }
//        }
        
        
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
  
  init(ddbb: TaskDatabase) {
    UITableView.appearance().separatorColor = .clear
    UITableView.appearance().backgroundColor = UIColor(named: "background")
    UITableViewCell.appearance().backgroundColor = UIColor(named: "background")
    self.ddbb = ddbb
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
    ContentView(ddbb: TaskDatabase(test: true))
  }
}


