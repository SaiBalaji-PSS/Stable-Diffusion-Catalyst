# Stable-Diffusion-Catalyst

##### A macOS Catalyst app which uses Apple's CoreML [Stable Diffusion](https://machinelearning.apple.com/research/stable-diffusion-coreml-apple-silicon) package to generate AI art on device in Apple Silicon SOC's  without a need for a backend server. 

[Blog](https://medium.com/@jokerpt/on-device-stable-diffusion-in-mac-catalyst-app-using-neural-engine-648876c6f41f)


##### Requirements
* MacOS 13.1 or later
* Xcode 14.2 or later
* Python 3.8
<img width="558" alt="Screenshot 2023-03-25 at 12 32 55 PM" src="https://user-images.githubusercontent.com/51410810/227760791-d13793f3-1abe-400b-bf86-bd63d1ccf57c.png">
<img width="558" alt="Screenshot 2023-03-25 at 12 44 21 PM" src="https://user-images.githubusercontent.com/51410810/227760795-a9610764-0463-44d7-b892-bea1e65f2b14.png">
<img width="558" alt="Screenshot 2023-03-25 at 1 49 31 PM" src="https://user-images.githubusercontent.com/51410810/227760804-50dc8238-2d03-458f-a8e5-d01bc6357133.png">

# Features
* Image to Image conversion
* Text to Image generation 
* Multi-threaded to run both I2I and T2I at same time

# Todo
* Proper UI
* Code clean up 
* Auto image resizing to 512X512 in Image to Image conversion
