//
//  SmartCamera.swift
//  FRUKTS
//
//  Created by Brian Fedelin on 6/5/21.
//

import SwiftUI
import AVFoundation

struct SmartCamera: View {
    var body: some View {
        CameraView()
    }
}

struct SmartCamera_Previews: PreviewProvider {
    static var previews: some View {
        SmartCamera()
         //   .previewDevice("iPhone 11 Pro Max")
    }
}

struct CameraView: View{
    
    @StateObject var camera = CameraModel()
    
    var body: some View{
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                if camera.isTaken{
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {camera.reTake()}, label: {
                            Image(systemName:
                                "arrow.uturn.forward.circle")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                
                HStack{
                   //if taken show options to save or take again
                    
                    if camera.isTaken{
                        
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding()
                        
                        Spacer()
                    }
                    else{
                        Button(action:{camera.takePic()}, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 70)
                            }
                            .padding()
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
        .alert(isPresented: $camera.alert){
            Alert(title: Text("Please Enable Camera Access"))
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    //since were going to read picture data..
    @Published var output = AVCapturePhotoOutput()
    
    //preview...
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    //picdata...
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func Check(){
        //first check if camera has permission
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //set up session
            setUp()
            return
        case .notDetermined:
            //retest for permission
            AVCaptureDevice.requestAccess(for: .video){(status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp(){
        //setting up the camera
        
        do{
            //setting configuration
            self.session.beginConfiguration()
            
            //change for own app
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{return}
            
            let input = try AVCaptureDeviceInput(device: device)
            
            //check and add to capture session
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            //same for output...
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        DispatchQueue.global(qos: .background).async {
       
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
            
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async{
                withAnimation{self.isTaken.toggle()}
                //clearing...
                
                self.isSaved = false
                self.picData = Data(count: 0)
                
            }
            
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil{
            return
        }
        
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
    }
    
    func savePic(){
        
        guard let image = UIImage(data: self.picData) else{return}
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("saved Successfully.... ")
    }
    
}

//setting up view for preview

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //your own video properties
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
