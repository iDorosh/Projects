/**
 * Created by Ian Dorosh on 11/18/15.
 * MDF 3 1511
 * Week 4 Mapping
 */

package idorosh.com.i_dorosh_mapping;


import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;



public class Details extends FragmentActivity {

    //Title and Caption labels
    TextView title;
    TextView caption;

    //Imgeview for the image being read from storage
    ImageView selectedImage;

    //Uri and Uri string
    //Uri set from Uri.parse(uriString)
    Uri uri;
    String uriString;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_details);

        //Setting references for the labels and the Image
        caption = (TextView) findViewById(R.id.caption);
        title = (TextView) findViewById(R.id.title);
        selectedImage = (ImageView) findViewById(R.id.selectedImage);

        //Setting labels from intent extras
        title.setText(getIntent().getStringExtra("title"));
        caption.setText(getIntent().getStringExtra("caption"));

        //Getting uri string with a substring method to get the correct directory
        uriString = getIntent().getStringExtra("imageUri").substring(5);
        //Creating Uri
        uri = Uri.parse(uriString);

        //Creating a bitmap and reducing the resolution of the image so that it can be displayed in imageview
        BitmapFactory.Options options;
        options = new BitmapFactory.Options();
        options.inSampleSize = 2;
        Bitmap bitmap = BitmapFactory.decodeFile(uriString, options);

        //Setting Image bitmap with the lower resolution image
        selectedImage.setImageBitmap(bitmap);
    }
}
