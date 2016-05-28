package com.idorosh.i_dorosh_multiactivity;

import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DetailActivity extends AppCompatActivity {

    //Array list is set to data in file
    List<Info> arrayList = new ArrayList<>();
    //Reference to read and write
    ReadAndWrite read = new ReadAndWrite();
    //Variable to hold current index of selected item
    int currentInt;
    //String to hold text that is pushed to another application
    String shareText;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Setting text_fragment as view
        setContentView(R.layout.text_fragment);

        //getting intent and extras from that intent
        Intent mIntent = getIntent();
        String currentSongTitle = mIntent.getExtras().getString("songTitle");
        String currentSongArtist = mIntent.getExtras().getString("songArtist");
        String currentSongAlbum = mIntent.getExtras().getString("songAlbum");
        currentInt = mIntent.getExtras().getInt("currentIndex");

        //Button and click listeners for delete and share_button
        View myButton = findViewById(R.id.delete);
        myButton.setOnClickListener(doSomething);

        View share = findViewById(R.id.share_button);
        share.setOnClickListener(doSomething);


        //Creating a share text with songs title, artist, and album
        shareText = currentSongTitle + " by " + currentSongArtist+" and the album is "+ currentSongAlbum;
        //Reading file to set array list value
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }


        //Display details method with intent extras and parameters
        displayDetails(currentSongTitle, currentSongArtist, currentSongAlbum);
    }


    //Do something method to either share data or delete based on which one is clicked.
    private View.OnClickListener doSomething = new View.OnClickListener() {

        @Override
        public void onClick(View _v) {

            //Runs when share button is clicked
            if (_v.getId() == R.id.share_button) {

                //Sending intent with plain text to an application
                Intent sendIntent = new Intent(Intent.ACTION_SEND);
                sendIntent.putExtra(Intent.EXTRA_TEXT, "Check out this song! "+ shareText);
                sendIntent.setType("text/plain");
                startActivity(Intent.createChooser(sendIntent, "Share Song Using..."));

                //Runs if the delete button is clicked.
            } else if (_v.getId() == R.id.delete) {
                //Removes that Item from array list
                arrayList.remove(currentInt);
                try {
                    //Saves the new array list to the file
                    saveFile((ArrayList) arrayList);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    };



    //Displays new selected information in the detail fragment
    void displayDetails(String s, String s1, String s2){

        TextView text1 = (TextView) findViewById(R.id.currentSong);
        text1.setText(s);

        TextView text2 = (TextView) findViewById(R.id.currentArtist);
        text2.setText(s1);

        TextView text3 = (TextView) findViewById(R.id.currentAlbum);
        text3.setText(s2);
    }

    //Saving method that calls createfile method in the read and write class
    public String saveFile(ArrayList info) throws IOException {

        boolean saved;
        FileOutputStream fos = openFileOutput("test.dat", MODE_PRIVATE);
        saved = read.createFile(fos, info);

        //If file is saved then the fragment is closed
        if (saved)
        {
            this.finish();
        }

        return null;
    }


    //Reads file and and sets the array list to that value
    public String readFile() throws IOException {
        FileInputStream fin = openFileInput("test.dat");
        arrayList = read.readFile(fin);
        return "hello";
    }
}
