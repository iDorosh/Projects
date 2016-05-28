/**
 * Created by Ian Dorosh on 11/18/15.
 * MDF 3 1511
 * Week 4 Mapping
 */

package idorosh.com.i_dorosh_mapping;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;


public class Form extends Activity {

    //Int for camera intent
    public static final int cameraRequest = 1;

    //Array list will hold all the information from the custom class
    ArrayList<Info> picInfo = new ArrayList<>();
    //Image view that will display the jpg taken by the camera
    ImageView capturedImage;

    //Uri of the image that was taken
    Uri uri;

    //Text fields for title and caption
    EditText title;
    EditText caption;

    //lat and lon passed through by the intent
    double lat;
    double lon;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form);

        //References for the camera button and the the image
        ImageButton imageButton = (ImageButton) findViewById(R.id.imageButton);
        imageButton.setOnClickListener(openCamera);
        capturedImage = (ImageView) findViewById(R.id.capturedImage);

        //References for the text fields
        title = (EditText) findViewById(R.id.titleText);
        caption = (EditText) findViewById(R.id.caption);

        //Setting lat and lon from the intent extras
        lat = getIntent().getExtras().getDouble("lat");
        lon = getIntent().getExtras().getDouble("lon");

        //Reading file will set picInfo to the correct value
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //Will start camera when the camera button is clicked
    private View.OnClickListener openCamera = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            uri = getImageUri();
            if(uri != null) {
                intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
            }
            startActivityForResult(intent, cameraRequest);

        }
    };

    private Uri getImageUri() {

        //Getting the pictures directory
        File picturesFolder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

        //Adding a Locations folder to the pictures folder
        File photosDir = new File(picturesFolder, "Locations");
        photosDir.mkdirs();

        //Creating a new file in the locations directory usign the edittext field as the name of the jpg
        File image = new File(photosDir, title.getText().toString() + ".jpg");
        try {
            image.createNewFile();
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }

        //Returning the photos uri;
        return Uri.fromFile(image);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //Will set the image on the add screen using a bitmap and the uri
        //Lowering resolution to display properly
        if(requestCode == cameraRequest && resultCode != RESULT_CANCELED) {
            if(uri != null) {
                BitmapFactory.Options options;
                options = new BitmapFactory.Options();
                options.inSampleSize = 2;
                Bitmap bitmap = BitmapFactory.decodeFile(uri.toString().substring(5), options);
                capturedImage.setImageBitmap(bitmap);

                //Adding the photo to the gallery
                addImageToGallery(uri);
            } else {
                capturedImage.setImageBitmap((Bitmap)data.getParcelableExtra("data"));
            }
        }
    }



    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_form, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_add) {
            //Will save all the information to the custom class and file
                savePic();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void savePic(){

        //Alert diolog to verify that the user wished to add the new photo.
        new AlertDialog.Builder(this)
                .setTitle("Save Photo")
                .setMessage("Would you like to save "+title.getText().toString())
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {

                        //Adding new info into arraylist
                        picInfo.add(new Info(title.getText().toString(), caption.getText().toString(), lon, lat, uri.toString()));
                        Toast.makeText(getBaseContext(), title.getText().toString() + " added", Toast.LENGTH_SHORT).show();

                        //Addpic will save all the photo information to a file as a serializable object
                        try {
                            addPic();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                    }
                })
                .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // do nothing
                    }
                })
                .show();
    }

    private void addPic() throws IOException {
        //Saves info to file
        saveFile(picInfo);

        //Creating a return intent so the new item can be added to the map
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MapsActivity.class);
        returnIntent.putExtra("picTitle", title.getText().toString());
        returnIntent.putExtra("picCaption", caption.getText().toString() );
        returnIntent.putExtra("lat", lat);
        returnIntent.putExtra("lon", lon);
        returnIntent.putExtra("newList", picInfo);
        setResult(RESULT_OK, returnIntent);

        //Closes out the activity
        finish();
    }

    private void addImageToGallery(Uri imageUri) {
        //Adding the photo to the gallery
        Intent scanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        scanIntent.setData(imageUri);
        sendBroadcast(scanIntent);
    }

    //Saving information to file
    public String saveFile(ArrayList info) throws IOException {

        WriteAndRead write = new WriteAndRead();
        FileOutputStream fos = openFileOutput("pictures.data", MODE_PRIVATE);

        write.createFile(fos, info);

        return null;
    }

    //Will call the method on ReadAndWrite class to read the photo information
    public ArrayList<Info> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("pictures.data");
        picInfo = getData.readFile(fin);
        return picInfo;
    }
}
