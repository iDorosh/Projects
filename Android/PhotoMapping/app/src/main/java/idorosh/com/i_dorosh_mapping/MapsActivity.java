package idorosh.com.i_dorosh_mapping;


import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;

public class MapsActivity extends FragmentActivity implements LocationListener, GoogleMap.OnInfoWindowClickListener, GoogleMap.OnMapLongClickListener {


    private GoogleMap mMap;

    //picInfo will hold the information about all the pictures
    ArrayList<Info> picInfo = new ArrayList<>();

    LocationManager manager;

    //Doubles will hold current postition Longittude and Latitude
    double latitude;
    double longitude;

    //Integer for starting activity for result
    public static final int addRequest = 1;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);

        //Reading file if there is one which will set the picInfo arrayList
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Setting up map and getting the locations longitude and latitude
        setUpMapIfNeeded();
        getLocation();

    }

    public void getLocation() {
        //Requesting location if none is available then a toast will pop up displaying location not found
        manager = (LocationManager) getSystemService(LOCATION_SERVICE);

        manager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5000, 10, this);

        Location location = manager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

        if(location == null) {
            Toast.makeText(getBaseContext(), "Location not found", Toast.LENGTH_SHORT).show();
        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_map, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_add) {
            //Will start add fragment and will pass the current lon and lat
           addIntent(latitude, longitude);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //Setting the picInfo to the updated list from add fragment by reading the updated file
        if (resultCode == RESULT_OK && requestCode == addRequest) {
            try {
                readFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            //Set markers will run through the list and create a marker for each object
            setCurrentMarkers();
        }

    }

    @Override
    protected void onResume() {
        super.onResume();
        setUpMapIfNeeded();
    }


    private void setUpMapIfNeeded() {
        //Will set up the map
        if (mMap == null) {
            mMap = ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map))
                    .getMap();
            if (mMap != null) {
                mMap.setOnInfoWindowClickListener(this);
                mMap.setOnMapLongClickListener(this);
            }
        }


    }

    private void setUpMap() {
        //Will clear the map of any circles or markers
        mMap.clear();
        //Zooming onto the current position
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(latitude, longitude), 17));
        //Adding a circle over current position
        mMap.addCircle(new CircleOptions()
                .fillColor(-3355444)
                .strokeColor(-1)
                .radius(8)
                .strokeWidth(5)
                .visible(true)
                .center(new LatLng(latitude, longitude)));

        //Set current markers will add all objects from the list
        setCurrentMarkers();
    }

    public void setCurrentMarkers(){
        //For loop will go through the obejcts in the list and will add markers for each
        for (int i = 0; i < picInfo.size(); i++) {
            mMap.addMarker(new MarkerOptions()
                    .position(new LatLng(picInfo.get(i).getmLat(), picInfo.get(i).getmLon()))
                    .title(picInfo.get(i).getmTitle()))
                    .setSnippet(picInfo.get(i).getmCaption());

        }

    }


    @Override
    public void onLocationChanged(Location location) {
        //Updates the lon and lat and updates map
        latitude = location.getLatitude();
        longitude = location.getLongitude();
        setUpMap();
    }

    @Override
    public void onInfoWindowClick(Marker marker) {
        int index;
        //Getting the id of the marker and removes the m to create an index which will be used to pass data
        index = Integer.parseInt(marker.getId().substring(1));

        //After adding a new Photo this will make sure that the index isn't greater that the amount of items in the list.
        if (index>=picInfo.size() ){
            index = picInfo.size()-1;
        }

        //Starting an intent to display information of the selected marker
        Intent intent = new Intent();
        intent.setClass(this, Details.class);
        intent.putExtra("title", picInfo.get(index).getmTitle() );
        intent.putExtra("caption", picInfo.get(index).getmCaption() );
        intent.putExtra("imageUri", picInfo.get(index).getmUri());
        startActivity(intent);
    }

    //Add Intent will run when the user clicks the plus in the action bar or will long press on the map
    //The parameters are either current location when the plus is clicked or
    //Location of the long press
    public void addIntent(double lat, double lon){
        Intent intent = new Intent();
        intent.setClass(this, Form.class);
        intent.putExtra("lat", lat);
        intent.putExtra("lon", lon);
        intent.putExtra("info", picInfo);
        startActivityForResult(intent, addRequest);

    }


    //Will read file and set picInfo to the correct value
    public ArrayList<Info> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("pictures.data");
        picInfo = getData.readFile(fin);
        return picInfo;
    }


    @Override
    public void onMapLongClick(LatLng latLng) {
        //Will start add activity when the user long clicks on the map
        addIntent(latLng.latitude, latLng.longitude);
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }


}
