//
//  PlateFilter.swift
//  imglyKit
//
//  Created by Carsten Przyluczky on 24/02/15.
//  Copyright (c) 2015 9elements GmbH. All rights reserved.
//

import Foundation

@objc(IMGLYPlateFilter) public class PlateFilter: ResponseFilter {
    init() {
        super.init(responseName: "Plate")
        self.displayName = "Plate"
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override var filterType:FilterType {
        get {
            return FilterType.Plate
        }
    }
}