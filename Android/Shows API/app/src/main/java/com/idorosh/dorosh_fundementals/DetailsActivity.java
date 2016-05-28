package com.idorosh.dorosh_fundementals;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;
import java.io.FileInputStream;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;


public class DetailsActivity extends Activity {

    List<Info> testing = new ArrayList<>();

    WriteAndRead saved = new WriteAndRead();
    String finalString;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Setting detail activity xml file as current view
        setContentView(R.layout.a_item);

        //Minimize keyboard on start of the app
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        //If the orientation is landscape then the detail fragment will display in the activities place
        if (getResources().getConfiguration().orientation
                == Configuration.ORIENTATION_LANDSCAPE) {
            finish();
            return;
        }



        //Getting array from strings xml
        String[] tvShows = getResources().getStringArray(R.array.shows);


        //Intent that is passed from titles fragment that holds the index of the selected row in the list view.
        Intent mIntent = getIntent();
        int intValue = mIntent.getIntExtra("index", 0);

        //Starts the process of checking network and then getting the api data
        //listItem(tvShows[intValue]);



        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();


       }
        if (testing.size() == 0){
            Toast.makeText(DetailsActivity.this, "Cache has been cleared", Toast.LENGTH_SHORT).show();
        }else {

            try {
                DisplayItems(testing, intValue);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }


    public String readFile() throws IOException {
        FileInputStream fin = openFileInput("test.dat");
        testing = saved.readFile(fin);
        System.out.println(testing);
        return finalString;

    }


    //Method to update text views
    public void DisplayItems(List<Info> testing, int currentInt) throws InterruptedException {


        TextView text1 = (TextView) findViewById(R.id.detailTitle);
        text1.setText(testing.get(currentInt).getmTitle().toString());

        TextView text2 = (TextView) findViewById(R.id.detailGenre);
        text2.setText(testing.get(currentInt).getmGenre().toString());

        TextView text3 = (TextView) findViewById(R.id.detailYear);
        text3.setText(testing.get(currentInt).getmYear().toString());

        TextView text4 = (TextView) findViewById(R.id.detailPlot);
        text4.setText(testing.get(currentInt).getmPlot().toString());

        //Timer to make sure that the text views are updated
        Thread.sleep(500);
        //Dismissing dialog


    }
}
