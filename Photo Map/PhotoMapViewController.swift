//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {

    @IBOutlet weak var mapKitView: MKMapView!
    
    var choosenImage: UIImage?
    var fullScreenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapKitView.setRegion(sfRegion, animated: false)
        mapKitView.delegate = self
    }
    
    @IBAction func tapCamera(sender: AnyObject) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tagSegue" {
            let locationView = segue.destinationViewController as! LocationsViewController
            locationView.delegate = self
        } else if segue.identifier == "fullImageSegue" {
            let fullImageViewController = segue.destinationViewController as! FullImageViewController
            fullImageViewController.image = choosenImage
        }
    }
}

extension PhotoMapViewController: UINavigationControllerDelegate {
}

extension PhotoMapViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        choosenImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true) { 
            self.performSegueWithIdentifier("tagSegue", sender: nil)
        }
    }
}

extension PhotoMapViewController: LocationsViewControllerDelegate {

    func locationsPickedLocation(controller: LocationsViewController, venue: Venue) {
        
        let annotation = PhotoAnnotation()
        let imageLocation = CLLocationCoordinate2DMake(CLLocationDegrees(venue.latitude!),
                                                       CLLocationDegrees(venue.longtitude!))
        annotation.coordinate = imageLocation
        annotation.title = venue.name
        annotation.photo = choosenImage
        mapKitView.addAnnotation(annotation)
        mapKitView.centerCoordinate = imageLocation
        self.navigationController?.popToViewController(self, animated: true)
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        }
        
        let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
        resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = thumbnail
        annotationView?.image = thumbnail
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control is UIButton {
            fullScreenImage = (view.annotation as! PhotoAnnotation).photo
            self.performSegueWithIdentifier("fullImageSegue", sender: nil)
        }
    }
}
