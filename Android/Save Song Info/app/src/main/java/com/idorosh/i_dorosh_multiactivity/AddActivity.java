package com.idorosh.i_dorosh_multiactivity;


import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class AddActivity extends AppCompatActivity {

    //Reference to Read and write class
    ReadAndWrite read = new ReadAndWrite();
    //Array list to hold information from the saved file
    List<Info> arrayList = new ArrayList<>();
    ////Reference to the list view fragment.
    ListViewFragment test = new ListViewFragment();
    //Array adapter
    ArrayAdapter songsAdapter;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_fragment);

        //Button to save song
        View myButton = findViewById(R.id.saveSong);
        myButton.setOnClickListener(saveSong);


        songsAdapter = test.songsAdapter;



    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add, menu);
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    //starts close activity method
    private View.OnClickListener saveSong = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            try {
                closeActivity();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    };



    void closeActivity() throws IOException {


        //Gets values from the add screen
        EditText artist = (EditText) findViewById(R.id.artistName);
        EditText title = (EditText) findViewById(R.id.songTitle);
        EditText album = (EditText) findViewById(R.id.albumTitle);


        //Adds values to the array list
        arrayList.add(new Info(title.getText().toString(), album.getText().toString(), artist.getText().toString()));


        //Saves array list to file
        saveFile((ArrayList) arrayList);

    }


    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {

        boolean saved;
        FileOutputStream fos = openFileOutput("test.dat", MODE_PRIVATE);

        saved = read.createFile(fos, info);

        //Closes activity when he file is saved.
        if (saved) {
            this.finish();
        }

        return null;
    }



    public List<Info> readFile() throws IOException {
        FileInputStream fin = openFileInput("test.dat");
        arrayList = read.readFile(fin);
        return arrayList;
    }

}
