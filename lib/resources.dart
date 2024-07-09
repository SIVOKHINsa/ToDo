const String flickrApiKey = '550d14fe53023610649a0dbf839b498e';
const String flickrBaseUrl = 'https://www.flickr.com/services/rest/';
const String flickrSearchMethod = 'flickr.photos.search';

String buildFlickrSearchUrl(String query) {
  return '$flickrBaseUrl?method=$flickrSearchMethod&api_key=$flickrApiKey&text=$query&format=json&nojsoncallback=1';
}