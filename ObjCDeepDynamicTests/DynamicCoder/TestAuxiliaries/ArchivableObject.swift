//
//  ArchivableObject.swift
//  ObjCDeepDynamic
//
//  Created on 16/10/2018.
//

import Foundation


@objc
internal class ArchivableObject: NSObject, NSCoding {
    var archivableEnum: ArchivableEnum
    
    init(_ archivableEnum: ArchivableEnum) {
        self.archivableEnum = archivableEnum
        super.init()
    }
    
    @objc
    required init?(coder aDecoder: NSCoder) {
        let archivableEnumObjC = aDecoder.decodeObject(forKey: "archivableEnum") as! ArchivableEnumObjCBridged
        archivableEnum = ArchivableEnum._unconditionallyBridgeFromObjectiveC(archivableEnumObjC)
        super.init()
    }
    
    @objc
    func encode(with aCoder: NSCoder) {
        aCoder.encode(archivableEnum._bridgeToObjectiveC(), forKey: "archivableEnum")
    }
}
