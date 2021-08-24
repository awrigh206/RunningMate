# Running Mate

Flutter application which will  be the mobile application which will perform all front end functionality for this project.

This application will connect with the REST API to provide the full functionality described in the 
report of this project.

The Spring REST API can be found here: https://github.com/awrigh206/RunningMateRest

The full code for this, Flutter mobile application is publicly available here: https://github.com/awrigh206/RunningMate

## Documentation
### Overview 
This is a mobile application built using cross-platform technologies, which means that the same code can be compiled for both Andoid and IOS devices. The application makes use of multiple features of modern smartphones namely: internet connectivity, Global Positioning System (GPS), vibration, and audio playback. It uses internet connectivity and GPS to keep track of how far the user has run and sends this information to the aforementioned server. The other player does this also, these values are then compared and both runners will then receive feedback on how they are performing in real-time via the screen of the device but also via audio and/or vibration (depending upon user settings).

### Security
For a system like this which required not only the creation of personal accounts (user names and passwords) but also processing the real-time, real-world location of users; certain security precautions were essential. One simple precaution was to change my plan so that the user's coordinates never left the device. Originally I had planned to do the distance traveled calculation on the server which would have involved sending both users coordinates there, but with research, I was able to find a mathematical way to calculate distance traveled from a previous coordinate on the mobile device and send this number instead. This meant that the most sensitive piece of data never left the device at all. In addition, I implemented HTTPS on all connections between the client and the server and ensured that all endpoints required authorisation to access. 
