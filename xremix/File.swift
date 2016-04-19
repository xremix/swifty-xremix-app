//
//  File.swift
//  xremix
//
//  Created by Toni Hoffmann on 19.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class File: NSObject {
    internal var Path: String?
    init(path: String) {
        super.init();
        self.Path = path
    }


}
