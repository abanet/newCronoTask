//
//  StringExtensions.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation


extension String {
    // Variable utilizada para la localización de los String
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    // Variable que elimina los espacios y saltos de línea tanto delante como detrás del String.
    var sinEspaciosExtremos: String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
