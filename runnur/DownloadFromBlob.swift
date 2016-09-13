//
//  DownloadFromBlob.swift
//  runnur
//
//  Created by Archana Vetkar on 01/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class DownloadFromBlob{
    
    func createContainer() {

        // Create a storage account object from a connection string.
        let account = try! AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=8jportalvhdshbrn9fzjhph5;AccountKey=442soY57EtVhXSnFRHsJSK3JD+9COPIUt7qDpKA8+uzi/EgsD4Ox64fMcPL4cpiFWrbQcQR+2XVb7GbfNRt1Tg==")
        // Create a blob service client object.
        let blobClient = account.getBlobClient()
        // Create a local container object.
        let blobContainer = blobClient.containerReferenceFromName("newcontainer")
        // Create container in your Storage account if the container doesn't already exist
        
        
        blobContainer.createContainerIfNotExistsWithCompletionHandler { (NSError, Bool) in
            if (NSError != nil) {
                print("Error in creating container.");
                }
        }
        
    }
    func listBlobsInContainer() {
        // Create a storage account object from a connection string.
        do{
            let account = try! AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=8jportalvhdshbrn9fzjhph5;AccountKey=442soY57EtVhXSnFRHsJSK3JD+9COPIUt7qDpKA8+uzi/EgsD4Ox64fMcPL4cpiFWrbQcQR+2XVb7GbfNRt1Tg==")
            // Create a blob service client object.
            let blobClient = account.getBlobClient()
            // Create a local container object.
            let blobContainer = blobClient.containerReferenceFromName("newcontainer")
            
            self.listBlobsInContainerHelper(blobContainer, continuationToken: nil, prefix: nil, blobListingDetails: AZSBlobListingDetails.All, maxResults: -1, completionHandler: {(error) -> Void in

                
            })
            
            
            
        }catch{
            print("error")
        }
    }
    func listBlobsInContainerHelper(container: AZSCloudBlobContainer, continuationToken: AZSContinuationToken?, prefix: String?, blobListingDetails: AZSBlobListingDetails, maxResults: Int, completionHandler: () -> Void)
    {
        container.listBlobsSegmentedWithContinuationToken(continuationToken, prefix: prefix, useFlatBlobListing: true, blobListingDetails: blobListingDetails, maxResults: maxResults, completionHandler: {(error, results) -> Void in
            if error != nil {
                //completionHandler(error)
            }
            else {
                print(results);
                for i in 0..<results!.blobs!.count {
                    print("\(results!.blobs![i])");   // as! AZSCloudBlockBlob).blobName()
                }
                if (results!.continuationToken != nil) {
                    self.listBlobsInContainerHelper(container, continuationToken: results!.continuationToken!, prefix: prefix, blobListingDetails: blobListingDetails, maxResults: maxResults, completionHandler: completionHandler)
                }
            }
        })
    }
    func uploadBlobToContainer() {
        var accountCreationError: NSError?
        // Create a storage account object from a connection string.
        let account = try! AZSCloudStorageAccount(fromConnectionString:"DefaultEndpointsProtocol=https;AccountName=8jportalvhdshbrn9fzjhph5;AccountKey=442soY57EtVhXSnFRHsJSK3JD+9COPIUt7qDpKA8+uzi/EgsD4Ox64fMcPL4cpiFWrbQcQR+2XVb7GbfNRt1Tg==")
        if accountCreationError != nil {
            print("Error in creating account.")
        }
        // Create a blob service client object.
        let blobClient = account.getBlobClient()
        // Create a local container object.
        let blobContainer = blobClient.containerReferenceFromName("newcontainer")
        blobContainer.createContainerIfNotExistsWithAccessType(AZSContainerPublicAccessType.Container, requestOptions: nil, operationContext: nil, completionHandler: {(error, exists) -> Void in
            if error != nil {
                print("Error in creating container.")
            }
            else {
                do {
                    // Create a local blob object
                    let blockBlob = blobContainer.blockBlobReferenceFromName("sampleblob")
                    // Upload blob to Storage
                
                    blockBlob.uploadFromText("This text will be uploaded to Blob Storage.", completionHandler: {(error) -> Void in
                        if error != nil {
                            print("Error in creating blob.");
                        }
                    })
                }
            }
            }
        )
    }
    
    func downloadBlobToString() {
        var accountCreationError: NSError?
        // Create a local blob object
        // Create a storage account object from a connection string.
        let account = try! AZSCloudStorageAccount(fromConnectionString:"DefaultEndpointsProtocol=https;AccountName=8jportalvhdshbrn9fzjhph5;AccountKey=442soY57EtVhXSnFRHsJSK3JD+9COPIUt7qDpKA8+uzi/EgsD4Ox64fMcPL4cpiFWrbQcQR+2XVb7GbfNRt1Tg==")
        if accountCreationError != nil {
            print("Error in creating account.")
        }
        // Create a blob service client object.
        let blobClient = account.getBlobClient()
       
        // Create a local container object.
        let blobContainer = blobClient.containerReferenceFromName("newcontainer")
        
        let blockBlob = blobContainer.blockBlobReferenceFromName("sampleblob")
        // Download blob
        
        blockBlob.downloadToTextWithCompletionHandler({(error, text) -> Void in
            if error != nil {
                print("Error in downloading blob")
            }
            else {
                print("\(text)")
            }
        })
    }
    
static  var containerNam = String();
static func downloadFromBlob(containerName:String)
 {
    containerNam = containerName;
    var err: NSError?
    let container = AZSCloudBlobContainer(url: NSURL(string: "https://runobjectblob.blob.core.windows.net/\(containerName)")!, error: &err)
    if ((err) != nil) {
        print("Error in creating blob container object.  Error code = %ld, error domain = %@, error userinfo = %@", err!.code, err!.domain, err!.userInfo);
    }
    else{
        print("successful container");
        
        let token = AZSContinuationToken();
        
        self.listBlobsInContainerHelper(container, continuationToken: token, prefix: "", blobListingDetails: AZSBlobListingDetails.All, maxResults: -1, completionHandler: {(error) -> Void in
            
            
//            if error != nil {
//                print("Error in creating container.")
//            }
        })
    }
    
   }
    
    static var data = String();
    
  static  func listBlobsInContainerHelper(container: AZSCloudBlobContainer, continuationToken: AZSContinuationToken, prefix: String, blobListingDetails: AZSBlobListingDetails, maxResults: Int, completionHandler: () -> Void) {
        
        
        
        container.listBlobsSegmentedWithContinuationToken(continuationToken, prefix: prefix, useFlatBlobListing: true, blobListingDetails: blobListingDetails, maxResults: maxResults, completionHandler: {(error, results) -> Void in
            if error != nil {
               // completionHandler(error)
            }
            else {
                for i in 0..<results!.blobs!.count {
                   // print("\(results!.blobs![i] as! AZSCloudBlockBlob).blobName()")
                    if let blockBlog = results!.blobs![i] as? AZSCloudBlockBlob
                    {
                      blockBlog.downloadToTextWithCompletionHandler({ (error, string) in
                        if (error != nil) {
                            print(error);
                        }else{
                            print("what getting \(string)");
                            if data == ""
                            {
                                data += "["+string!+"]";
                                print(data)
                                writeToFile(data, contName: containerNam)
                            }else{
                                let trucated = data.characters.dropLast();
                                data = String(trucated)+","+string!+"]";
                                print(data)
                                writeToFile(data, contName: containerNam)
                            }
                        }
                      })
                    }
                   
                    
                }
              //  writeToFile(data, contName: containerNam)
                if (results!.continuationToken != nil) {
                     self.listBlobsInContainerHelper(container, continuationToken: (results?.continuationToken)!, prefix: prefix, blobListingDetails: blobListingDetails, maxResults: maxResults, completionHandler: completionHandler)
                }
            }
        })
    }
    
   static var firstCache : String? = nil;
   static func writeToFile(newItem:String,contName:String)
    {
        
        let file = "\(contName).txt" //this is the file. we will write to and read from it
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        let path = paths.URLByAppendingPathComponent(file)
        
        //------------------------ store data in cache/file --------------------------
        
        
        do{
            firstCache = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String;
        }
        catch{
            
        }
        if firstCache == nil{
                do {
                    //let item = "["+newItem+"]"
                    try newItem.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                    print("newItem :---\(newItem)")
                }
                catch {/* error handling here */
                    print(error);
                    print("error while write");
                }
        }else{
           // let trucated = firstCache?.characters.dropLast();
              //  firstCache = String(trucated!)+", "+newItem+"]";
                do {
                    try newItem.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                }
                catch {/* error handling here */
                    print(error);
                    print("error while write");
                }
            
        }
    }
  
    
    
    
    
    


    
}