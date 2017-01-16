//
//  ImageSample.swift
//  OMHClient
//
//  Created by James Kizer on 1/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

final class ImageSample: OMHMediaDataPointBase {
    
    public init(imageURL: URL) {
        
        super.init()
        
        let attachment = OMHMediaAttachment(fileName: "image", fileURL: imageURL, mimeType: "image/png")
        self.addAttachment(attachment: attachment)
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override var schema: OMHSchema {
        return OMHSchema(
            name: "example-image",
            version: "1.0",
            namespace: "cornell")
    }
    
    override var body: [String: Any] {
        return ["image": "image"]
    }
}
