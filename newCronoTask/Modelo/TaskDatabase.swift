//
//  TaskDatabase.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit
import FMDB


class TaskDatabase: ObservableObject {
  
  let databaseName = "CronoTask.db"
  let databasePath: String
  @Published var tareas: [Tarea] = [Tarea]()
 
  // Init de la base de datos
  // Si no existe un fichero CronoTask.db se crea y se crea la estructura de la base de datos.
  // Si ya existe una base de datos se obtienen las tareas que pueda contener.
  init() {
    // Ruta de la base de datos
    let filemgr = FileManager.default
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    databasePath = documentsPath.appending("/\(databaseName)")
    print("Base de datos: \(databasePath)")
    
    // Creación de la base de datos o recuperación de las tareas si ya existía
    if !filemgr.fileExists(atPath: databasePath){
      //No existe la base de datos. Creamos la base de datos.
      let taskDB = FMDatabase(path: databasePath)
      if taskDB.open() {
        // tabla de tareas
        let sql_crear_tareas = "CREATE TABLE IF NOT EXISTS TASKS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESCRIPCION TEXT, FECHA TEXT, HORA TEXT, ULTIMAVEZ TEXT)"
        if !taskDB.executeStatements(sql_crear_tareas) {
          print("Error: \(taskDB.lastErrorMessage())")
        }
        // tabla de ocurrencias
        let sql_crear_ocurrencias = "CREATE TABLE IF NOT EXISTS OCURRENCIAS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDTASK INTEGER, FECHA TEXT, HORA TEXT, TIEMPO TEXT)"
        if !taskDB.executeStatements(sql_crear_ocurrencias) {
          print("Error: \(taskDB.lastErrorMessage())")
        }
        taskDB.close()
      }
      
    } else {
      // La base de datos existe.
      let taskDB = FMDatabase(path: databasePath)
      taskDB.logsErrors = true
      self.tareas = self.leerTareas()
    }
  }
  
  init(test: Bool) {
    self.databasePath = ""
    if test {
      let nombresTareas = ["Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS", "Guitarra", "Flow", "Percusión", "Piano", "Estudio iOS"]
      self.tareas = nombresTareas.map {
        Tarea(nombre: $0)
      }
    }
  }
  // MARK: Tratamiento de las tareas
  
  // ¿Existe una tarea con esa misma descripcion en la base de datos?
  func existeTarea(t:Tarea) -> Bool {
    for unaTarea in tareas {
      if unaTarea == t {
        return true
      }
    }
    return false
  }
  
  // Encontrar una tarea dada la descripción
  func tareaConNombre(_ descripcion: String) -> Tarea? {
    for unaTarea in tareas {
      if unaTarea.nombre == descripcion {
        return unaTarea
      }
    }
    return nil
  }
  
  // Añadir Tareas
  func addTask(tarea:Tarea) {
    let database = FMDatabase(path: self.databasePath)
    if database.open() {
      let insertSQL = "INSERT INTO TASKS (DESCRIPCION, FECHA, HORA, ULTIMAVEZ) VALUES ('\(tarea.nombre)', '\(tarea.fechaCreacion)', '\(tarea.horaCreacion)', '\(tarea.fechaUltimaVezUtilizada)')"
      print("addTask: \(insertSQL)")
      
      let resultado = database.executeUpdate(insertSQL, withArgumentsIn: [])
      if !resultado {
        print("Error: \(database.lastErrorMessage())")
      } else {
        print("Tarea añadida")
        self.tareas.insert(tarea, at: 0)
        
      }
    }
  }
  
  
  // Eliminar Tarea
  // TODO: eliminar las ocurrencias asociadas a dicha tarea
  func removeTask(tarea:Tarea)->Bool {
    if let idddbb = tarea.idTarea { //si no hay identificador se está intentando borrar una tarea que aún no ha sido grabada.
      let database = FMDatabase(path: self.databasePath)
      if database.open() {
        let deleteSQL = "DELETE FROM TASKS WHERE ID = '\(idddbb)'"
        let resultado = database.executeUpdate(deleteSQL, withArgumentsIn: [])
        if !resultado {
          print("Error: \(database.lastErrorMessage())")
          return false
        } else {
          removeOcurrencias(idTask: idddbb)
          print("Tarea eliminada")
        }
      }
    }
    return true
  }
  
  // Se leen las tareas que hay almacenadas en la base de datos y se devuelven en un array.
  func leerTareas() -> [Tarea] {
    var arrayResultado = [Tarea]()
    let database = FMDatabase(path: self.databasePath)
    if database.open() {
      let selectSQL = "SELECT ID, DESCRIPCION, FECHA, HORA, ULTIMAVEZ FROM TASKS"
      let resultados: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: [])
      while resultados?.next() == true {
        let tarea: Tarea = Tarea(id: resultados!.string(forColumn: "ID")!,
                                 nombre: resultados!.string(forColumn: "DESCRIPCION")!,
                                 fecha: resultados!.string(forColumn: "FECHA")!,
                                 hora: resultados!.string(forColumn: "HORA")!,
                                 fechaUltimaVez: resultados!.string(forColumn: "ULTIMAVEZ")!)
        tarea.tiempoAcumulado = calcularTiempoAcumulado(idTask: tarea.idTarea!) ?? "00:00,00"
        tarea.ocurrencias = self.leerOcurrencias(idTask: resultados!.string(forColumn: "DESCRIPCION")!)
        print("Ocurrencias para \(tarea.nombre): \(tarea.ocurrencias)")
        arrayResultado.append(tarea)
      }
    } else {
      // problemas al abrir la base de datos
    }
    return arrayResultado
  }
  
  func idParaTarea(descrip: String) -> String? {
    // Primero buscamos en la caché: el array de tareas
    for tarea in self.tareas {
      if tarea.nombre == descrip, tarea.idTarea != nil {
        return tarea.idTarea!
      } 
    }
    // y si no estaba lo buscamos en la base de datos.
    let database = FMDatabase(path: self.databasePath)
    if database.open() {
      let selectSQL = "SELECT ID FROM TASKS WHERE DESCRIPCION = '\(descrip)'"
      let resultado: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: [])
      if resultado!.next() {
        return resultado!.string(forColumn: "ID")!
      }
      database.close()
    }
    return nil
  }
  
  func renombrarTarea(_ task:Tarea, anteriorNombre: String, nuevoNombre:String) {
    // Realizamos el cambio en la base de datos
    if let id = task.idTarea {
        let database = FMDatabase(path: self.databasePath)
        if database.open() {
          let modifySQL = "UPDATE TASKS SET DESCRIPCION = '\(task.nombre)' WHERE ID = '\(id)'"
          print("Modificando Tarea: \(modifySQL)")
          let resultado = database.executeUpdate(modifySQL, withArgumentsIn: [])
          if !resultado {
            print("Error: \(database.lastErrorMessage())")
          } else {
            // cambiamos el nombre en el array
            renombrarTareaEnArray(anteriorNombre: anteriorNombre, nuevoNombre: nuevoNombre)
            print("Tarea modificada.")
          }
        }
    } else {
      // cambiamos el nombre en el array
      renombrarTareaEnArray(anteriorNombre: anteriorNombre, nuevoNombre: nuevoNombre)
    }
  }
  
  
  // Recorre el array de tareas y realiza un cambio de nombre.
  func renombrarTareaEnArray(anteriorNombre: String, nuevoNombre:String) {
    for (indice, unaTarea) in tareas.enumerated() {
      if unaTarea.nombre == anteriorNombre {
        unaTarea.nombre = nuevoNombre
        tareas[indice] = unaTarea
        break
      }
    }
  }
  // MARK: Tratamiento de las Ocurrencias
  
  // Graba una Ocurrencia a la base de datos
  func addOcurrencia(_ ocu: Ocurrencia) {
      let database = FMDatabase(path: self.databasePath)
      if database.open() {
        let insertSQL = "INSERT INTO OCURRENCIAS (IDTASK, FECHA, HORA, TIEMPO) VALUES ('\(ocu.idTask!)', '\(ocu.fecha)', '\(ocu.hora)', '\(ocu.reloj.tiempo)')"
        print("addOcurrencia: \(insertSQL)")
        let resultado = database.executeUpdate(insertSQL, withArgumentsIn: [])
        if !resultado {
          print("Error: \(database.lastErrorMessage())")
        } else {
          // añadir la ocurrencia a la tarea correspondiente
          if let tarea = tareaConNombre(ocu.idTask!) {
            tarea.ocurrencias.append(ocu)
            showBBDD()
          }
        }
      }
  }
  
  // Elimina las ocurrencias asociadas a una tarea concreta.
  func removeOcurrencias(idTask id:String) {
      let database = FMDatabase(path: self.databasePath)
      if database.open() {
        let deleteSQL = "DELETE FROM OCURRENCIAS WHERE IDTASK = '\(id)'"
        let resultado = database.executeUpdate(deleteSQL, withArgumentsIn: [])
        if !resultado {
          print("Error: \(database.lastErrorMessage())")
        } else {
          print("Ocurrencia eliminada")
        }
      }
  }
  
  func removeOcurrencia(_ ocurrencia: Ocurrencia) {
    let database = FMDatabase(path: self.databasePath)
    if database.open() {
      let deleteSQL = "DELETE FROM OCURRENCIAS WHERE IDTASK = '\(ocurrencia.idTask)' AND FECHA = '\(ocurrencia.fecha)' AND HORA = '\(ocurrencia.hora)'"
      let resultado = database.executeUpdate(deleteSQL, withArgumentsIn: [])
      if !resultado {
        print("Error: \(database.lastErrorMessage())")
      } else {
        print("Ocurrencia eliminada")
      }
    }
  }
  
  
  // Se leen las ocurrencias que hay almacenadas en la base de datos y se devuelven en un array.
  func leerOcurrencias(idTask:String) -> [Ocurrencia] {
    var arrayResultado = [Ocurrencia]()
      let database = FMDatabase(path: self.databasePath)
      if database.open() {
        let selectSQL = "SELECT ID, IDTASK, FECHA, HORA, TIEMPO FROM OCURRENCIAS WHERE IDTASK = '\(idTask)'"
        let resultados: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: [])
        while resultados?.next() == true {
          let ocurrencia: Ocurrencia = Ocurrencia(idTask: resultados!.string(forColumn: "IDTASK")!,
                                                  fecha: resultados!.string(forColumn: "FECHA")!,
                                                  hora: resultados!.string(forColumn: "HORA")!,
                                                  tiempo: resultados!.string(forColumn: "TIEMPO")!)
          arrayResultado.append(ocurrencia)
        }
      } else {
        // problemas al abrir la base de datos
      }
    print("Ocurrencias leídas:\(arrayResultado)")
    return arrayResultado
  }
  
  
  
  // Calcular un String con el tiempo acumulado de todas las ocurrencias para añadir al acumulado de la tarea
  func calcularTiempoAcumulado(idTask:String) -> String? {
    let ocurrencias: [Ocurrencia] = self.leerOcurrencias(idTask: idTask)//self.leerOcurrencias(idTask: idTask)
    if !ocurrencias.isEmpty {
      var relojFinal = Reloj()
        for unaOcurrencia in ocurrencias {
          relojFinal = Reloj.sumar(reloj1: relojFinal, reloj2:unaOcurrencia.reloj)
        }
      return relojFinal.tiempo
    } else {
      return nil
    }
  }
  
  // MARK: Mostrar contenido bbdd para depuración
  func showBBDD() {
    for tarea in tareas {
      print("Tarea -> \(tarea.nombre)")
      for ocurrencia in tarea.ocurrencias {
        print("Ocurrencia: \(ocurrencia.fecha) - \(ocurrencia.hora)")
      }
    }
  }
}
