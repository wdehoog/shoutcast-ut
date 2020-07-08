## shoutcast-ut

A SHOUTcast player for Ubuntu Touch. This project is for me to see how 'portable' QML is and how hard/easy it is to create an app for Ubuntu Touch. 

The code is based on my shoutcast-sailfish app. 

### Functionality
  * Browse by Genre
  * List Top 500
  * Search by 'Now Playing' or Keywords
  * Play/Pause

### Issues
  * If there is no network then you are toast
  * The app checks if the Audio object has meta data available like current track info but appearently
    this is not implemented in UT. See https://bugs.launchpad.net/bugs/1586230.

### Thanks
  * SHOUTcast for www.shoutcast.com
  * the UT Team for Ubuntu Touch
  * Romain Pokrzywka: JSONListModel
  * Stefan Goessner: JSONPath
  * igh0zt: app icon
  * the translators
