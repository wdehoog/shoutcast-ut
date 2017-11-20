## shoutcast-ubports

A SHOUTcast player for UBPorts. This project is for me to see how 'portable' QML is and how hard/easy it is to create an app for UBPorts. 

The code is based on my shoutcast-sailfish app. While developing I test it on my Moto G 2014 (titan).

### Functionality
  * Browse by Genre
  * List Top 500
  * Search by 'Now Playing' or Keywords
  * Play/Pause

### Issues
  * If there is no network then you are toast
  * The stations lists can show the logos (see the Settings page) but it makes the app crash a lot.
  * The app checks if the Audio object has meta data available like current track info but appearently
    this is not implemented in UBPorts. See https://bugs.launchpad.net/bugs/1586230.

### Thanks
  * SHOUTcast for www.shoutcast.com
  * the UBPorts Team for UBPorts
  * walidham for his UBPorts port for titan
  * mimecar for his VirtualBox VM with the Ubuntu SDK
  * Romain Pokrzywka: JSONListModel
  * Stefan Goessner: JSONPath
  * igh0zt: app icon
  * https://feathericons.com/: some icons
  * Canonical: ubuntu-touch. Why did you stop?
